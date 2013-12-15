package com.exitapplication;

import java.util.ArrayList;
import java.util.List;

import com.exitapplication.lib.UrlLoader;
import com.exitapplication.lib.signal.SignalEvent;
import com.exitapplication.module.TurnController;
import com.exitapplication.module.data.UserSeatData;
import com.exitapplication.module.external.ExternalConst;
import com.exitapplication.module.external.OnUserDeal;
import com.exitapplication.module.external.OnUserOut;
import com.exitapplication.module.external.TestExt;
import com.exitapplication.module.external.UserSitEvent;
import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class TexasExtension extends SFSExtension
{
	private final String WAIT_PLAYER_STATE = "waitplayer";
	private final String START_LOAD_CONFIG_STATE = "startloadconfig";
	private final String START_TURN_STATE = "startturn";
	
	private String currentState = WAIT_PLAYER_STATE;
	
	private UrlLoader urlLoaderStartGame = new UrlLoader(this);
	
	//seat
	private TurnController turnController = new TurnController(this);
	private UserSeatData[] userSeatDatas;
	private int numUserSeated = 0;
	
	private String configData = "";
	
	
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
		
		
//		addEventHandler(SFSEventType.USER_JOIN_ROOM, OnUserIn.class);
		addEventHandler(SFSEventType.USER_DISCONNECT, OnUserOut.class);
		addEventHandler(SFSEventType.USER_LEAVE_ROOM, OnUserOut.class);
		addEventHandler(SFSEventType.PLAYER_TO_SPECTATOR, OnUserOut.class);
		
		
		urlLoaderStartGame.signalComplete.add(new SignalEvent(){
			public void dispatch(Object...args)
			{
				configData = (String) args[0];
				currentState = START_TURN_STATE;
				trace("loaded config");
				turnController.start( configData , userSeatDatas.clone() );
			}
		});
		urlLoaderStartGame.signalError.add(new SignalEvent(){
			public void dispatch(Object...args)
			{
				configData = (String) args[0];
				currentState = START_TURN_STATE;
				trace("error config : "+configData);
				turnController.start( configData , userSeatDatas.clone() );
			}
		});
	}
	
	public void addUser(User user , int sitIndex )
	{
		List<User> users = getParentRoom().getUserList();
		for( int i=0 ; i<=users.size()-1 ; i++ ){
			trace("id : "+users.get(i).getId()+" name:"+users.get(i).getName());
		}
		trace(" add user id : "+user.getId()+" user name : "+user.getName() );
		
		trace("userSeatDatas[sitIndex]:"+ (userSeatDatas[sitIndex]==null) );
		if( userSeatDatas[sitIndex]!=null ){
			SFSObject sfsObject = new SFSObject();
			sfsObject.putUtfString(ExternalConst.REASON, "Your seat has reserved.");
			send(ExternalConst.ON_SIT_ERROR, sfsObject, user);
			return;
		}
		
		userSeatDatas[sitIndex] = new UserSeatData(user, sitIndex);
		numUserSeated++;
		
		traceUserSeat();
		
		SFSObject sfsObj = new SFSObject();
		sfsObj.putInt(ExternalConst.SIT_POSITION, sitIndex);
		sfsObj.putInt(ExternalConst.USER_ID, user.getId());
		sfsObj.putInt(ExternalConst.TURN, user.getId());
		send(ExternalConst.ON_SIT_COMPLETE, sfsObj, getParentRoom().getUserList());
		
		if( currentState==WAIT_PLAYER_STATE && numUserSeated>=2 ){
			startLoadConfig();
		}
	}
	
	public void addUserError(User user , String resaon)
	{
		SFSObject sfsObject = new SFSObject();
		sfsObject.putUtfString("reason", resaon);
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
	}
	
	public void userDeal(int value , int userId )
	{
		turnController.userDeal(value,userId);
	}
	
	private void startLoadConfig()
	{
		trace("startLoadConfig()");
		currentState = START_LOAD_CONFIG_STATE;
		
		
//		URLLoader1 urlLoader = new URLLoader1();
//		urlLoader.load2("http://texasgenius.com/phpsys/action.php", this);
		
		
		urlLoaderStartGame.addParam("action_option","getCard");
		
		ArrayList<UserSeatData> playerArray = new ArrayList<UserSeatData>();
		for( int i=0 ; i<=userSeatDatas.length-1 ; i++){
			if( userSeatDatas[i] !=null ){
				playerArray.add(userSeatDatas[i]);
			}
		}
		
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
		urlLoaderStartGame.addParam("name",nameString);
		
		urlLoaderStartGame.load(ExternalConst.ALL_CARD_URL);
		
//		urlLoader.load("http://texasgenius.com/phpsys/action.php?action_option=getCard&token=1&fbid=1&name=[\"eknimation\",\"akekapon\",\"ake\"]");
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
		resObj.putUtfString("t", "0.2a");
		resObj.putUtfString("data", s);
		send("test", resObj, getParentRoom().getUserList());
	}
}
