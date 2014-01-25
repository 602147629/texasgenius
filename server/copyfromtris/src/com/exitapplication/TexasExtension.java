package com.exitapplication;

import java.util.ArrayList;
import java.util.List;

import com.exitapplication.lib.UrlLoader;
import com.exitapplication.lib.signal.SignalEvent;
import com.exitapplication.module.TurnController;
import com.exitapplication.module.data.UserSeatData;
import com.exitapplication.module.external.ExternalConst;
import com.exitapplication.module.external.OnUserDeal;
import com.exitapplication.module.external.OnUserJoin;
import com.exitapplication.module.external.OnUserOut;
import com.exitapplication.module.external.OnUserSendData;
import com.exitapplication.module.external.OnUserSendEmotion;
import com.exitapplication.module.external.OnUserSendGift;
import com.exitapplication.module.external.TestExt;
import com.exitapplication.module.external.UserSitEvent;
import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class TexasExtension extends SFSExtension
{
	public final String WAIT_PLAYER_STATE = "waitplayer";
	public final String START_LOAD_CONFIG_STATE = "startloadconfig";
	public final String START_TURN_STATE = "startturn";
	
	public String currentState = WAIT_PLAYER_STATE;
	
	private UrlLoader urlLoaderStartGame;
	
	//seat
	public TurnController turnController = new TurnController(this);
	public String configData = "";
	private UserSeatData[] userSeatDatas;
	private UserSeatData[] canPlayUserSeatDatas;
	private int numUserSeated = 0;
	
	@Override
	public void init()
	{
		userSeatDatas = new UserSeatData[getParentRoom().getMaxUsers()];
		
		// EXIT
		addRequestHandler("test", TestExt.class);
		addRequestHandler(ExternalConst.USER_SIT, UserSitEvent.class);
		
		/*addRequestHandler(ExternalConst.PROVIDE_CONFIG, new BaseClientRequestHandler() {
			@Override
			public void handleClientRequest(User user, ISFSObject params)
			{
				ISFSObject resObj = new SFSObject();
				resObj.putUtfString(ExternalConst.CONFIG_DATA,params.getUtfString(ExternalConst.CONFIG_DATA));
				send(ExternalConst.PROVIDE_CONFIG, resObj, getParentRoom().getUserList());
			}
		});*/
		
		addRequestHandler(ExternalConst.USER_DEAL,OnUserDeal.class);
		addRequestHandler(ExternalConst.DATA,OnUserSendData.class);
		addRequestHandler(ExternalConst.SEND_GIFT,OnUserSendGift.class);
		addRequestHandler(ExternalConst.SEND_EMOTION,OnUserSendEmotion.class);
		
		addEventHandler(SFSEventType.USER_JOIN_ROOM, OnUserJoin.class);
		addEventHandler(SFSEventType.USER_DISCONNECT, OnUserOut.class);
		addEventHandler(SFSEventType.USER_LEAVE_ROOM, OnUserOut.class);// not call
		addEventHandler(SFSEventType.PLAYER_TO_SPECTATOR, OnUserOut.class);
		
		turnController.signalEnd.add( new SignalEvent(){
			public void dispatch(Object...args)
			{
				configData = "";
				urlLoaderStartGame.dispose();
				ArrayList<UserSeatData> playerArray = getUserSitDatas();
				if( playerArray.size() >= 2 ){
					startLoadConfig();
				}else{
					currentState = WAIT_PLAYER_STATE;
				}
			}
		});
	}
	
	public void addUser(User user , int sitIndex , String fbuid ,  String playerStatus )
	{
		List<User> users = getParentRoom().getUserList();
		for( int i=0 ; i<=users.size()-1 ; i++ ){
			trace("id : "+users.get(i).getId()+" name:"+users.get(i).getName());
		}
		trace(" add user id : "+user.getId()+" user name : "+user.getName() );
		
		trace("userSeatDatas["+sitIndex+"]:"+ (userSeatDatas[sitIndex]==null) );
		if( userSeatDatas[sitIndex]!=null ){
			SFSObject sfsObject = new SFSObject();
			sfsObject.putUtfString(ExternalConst.REASON, "Your seat has reserved.");
			send(ExternalConst.ON_SIT_ERROR, sfsObject, user);
			return;
		}
		userSeatDatas[sitIndex] = new UserSeatData(user, fbuid , sitIndex , playerStatus);
		numUserSeated++;
		trace("numUserSeated add:"+numUserSeated);
		
		traceUserSeat();
		
		SFSObject sfsObj = new SFSObject();
		sfsObj.putInt(ExternalConst.SIT_POSITION, sitIndex);
		sfsObj.putInt(ExternalConst.USER_ID, user.getId());
		sfsObj.putUtfString(ExternalConst.FB_UID, fbuid);
		sfsObj.putUtfString(ExternalConst.PLAYER_STATUS, userSeatDatas[sitIndex].playerStatus);
		send(ExternalConst.ON_SIT_COMPLETE, sfsObj, getParentRoom().getUserList());
		
		trace("currentState:"+currentState);
		if( currentState==WAIT_PLAYER_STATE && numUserSeated>=2 ){
			//canPlayUserSeatDatas = userSeatDatas.clone();
			startLoadConfig();
		}
	}
	
	public void addUserError(User user , String resaon)
	{
		SFSObject sfsObject = new SFSObject();
		sfsObject.putUtfString(ExternalConst.REASON, resaon);
		send(ExternalConst.ON_SIT_ERROR, sfsObject, user);
	}
	
	public void removeUser(User user)
	{
		for( int i=0 ; i<=userSeatDatas.length-1 ; i++){
			if( userSeatDatas[i]!=null && userSeatDatas[i].user.getId() == user.getId() ){
				userSeatDatas[i] = null;
			}
		}
		traceUserSeat();
		numUserSeated--;
		trace("numUserSeated remove:"+numUserSeated);
		
		if( currentState==WAIT_PLAYER_STATE){
			
		}else if(currentState==START_LOAD_CONFIG_STATE){
			if( numUserSeated<2 ){
				urlLoaderStartGame.dispose();
				currentState = WAIT_PLAYER_STATE;
			}
		}else if(currentState==START_TURN_STATE){
			turnController.userOut(user);
		}
	}
	
	public void userDeal(int value , int userId )
	{
		turnController.userDeal(value,userId);
	}
	
	private void startLoadConfig()
	{
		canPlayUserSeatDatas = userSeatDatas.clone();
		ArrayList<UserSeatData> playerArray = getUserSitDatas();
		traceUserSeat();
		if( playerArray.size()<2 ){
			return;
		}
		trace("startLoadConfig()");
		currentState = START_LOAD_CONFIG_STATE;
		
		String nameString = "[";
		for( int i=0 ; i<=playerArray.size()-1 ; i++ ){
			String name = playerArray.get(i).user.getName();
			trace("  name:"+name);
			nameString += "\""+name+"\"";
			trace("  nameString:"+nameString);
			if( i!=playerArray.size()-1 ){
				nameString += ",";
			}
		}
		nameString += "]";
		
		trace(" param load : "+nameString);
		
		urlLoaderStartGame = new UrlLoader();
		urlLoaderStartGame.addParam("action_option","getCard");
		urlLoaderStartGame.addParam("name",nameString);
		urlLoaderStartGame.addParam("roomid",Integer.toString(getParentRoom().getId()) );
		
		urlLoaderStartGame.signalComplete.add(new SignalEvent(){
			public void dispatch(Object...args)
			{
				configData = (String) args[0];
				currentState = START_TURN_STATE;
				trace("loaded config");
				turnController.start( configData , canPlayUserSeatDatas );
				urlLoaderStartGame.dispose();
			}
		});
		urlLoaderStartGame.signalError.add(new SignalEvent(){
			public void dispatch(Object...args)
			{
				configData = (String) args[0];
				currentState = START_TURN_STATE;
				trace("error config : "+configData);
				turnController.start( configData , canPlayUserSeatDatas );
			}
		});
		
		urlLoaderStartGame.load(ExternalConst.ALL_CARD_URL);
	}
	
	public ArrayList<UserSeatData> getUserSitDatas()
	{
		ArrayList<UserSeatData> playerArray = new ArrayList<UserSeatData>();
		for( int i=0 ; i<=userSeatDatas.length-1 ; i++){
			if( userSeatDatas[i] !=null ){
				playerArray.add(userSeatDatas[i]);
			}
		}
		return playerArray;
	}
	
	@Override
	public void destroy()
	{
		super.destroy();
		trace("Tris game destroyed!");
	}
	
	public void traceUserSeat()
	{
		String str = " USER SEAT :::: [";
		for( int i=0 ; i<=userSeatDatas.length-1 ; i++){
			if( userSeatDatas[i] != null ){
				str += i+" : "+userSeatDatas[i].user.getId()+" , ";
			}
		}
		trace(str+"]");
	}
	
	public void trace( String s )
	{
		ISFSObject resObj = new SFSObject();
		resObj.putUtfString("t", "0.3b");
		resObj.putUtfString("data", s);
		send("test", resObj, getParentRoom().getUserList());
	}
}