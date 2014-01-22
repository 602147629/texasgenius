package com.exitapplication.module;

import java.util.ArrayList;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.exitapplication.TexasExtension;
import com.exitapplication.lib.UrlLoader;
import com.exitapplication.lib.signal.Signal;
import com.exitapplication.lib.signal.SignalEvent;
import com.exitapplication.module.data.UserSeatData;
import com.exitapplication.module.external.ExternalConst;
import com.smartfoxserver.v2.SmartFoxServer;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class TurnController {
	final private int TIME_OUT_DISTRIBUTE_CARD = 5; 
	final private int TIME_OUT_TURN = 10; 
	final private int TIME_OUT_END = 5; 
	final private int MAX_CARD_TURN = 3; 
	
	public Signal signalEnd = new Signal();
	public String configData = "";
	public ArrayList<UserSeatData> activePlayerArray = new ArrayList<UserSeatData>();
	
	private TexasExtension texasExtension;
	private ArrayList<UserSeatData> playerArray = new ArrayList<UserSeatData>();
	private int currentPlayerTurnIndex = -1;
	private int currentCardTurn = -1;
	
	
	private SmartFoxServer sfs = SmartFoxServer.getInstance();
	private ScheduledFuture<?> taskHandle;
	private long t = 0;

	public TurnController(TexasExtension texasExtension) {
		this.texasExtension = texasExtension;
	}

	@SuppressWarnings("unchecked")
	public void start(String configData, UserSeatData[] seatArray) 
	{
		this.configData = configData;
		currentCardTurn = 0;
		currentPlayerTurnIndex = 0;
		
		
		
		SFSObject sfsObj = new SFSObject();
		sfsObj.putUtfString(ExternalConst.CONFIG_DATA, configData);
		texasExtension.send(ExternalConst.START_GAME_TURN, sfsObj, texasExtension.getParentRoom().getUserList());
		
		
		playerArray = new ArrayList<UserSeatData>();
		for( int i=0 ; i<=seatArray.length-1 ; i++){
			if( seatArray[i] !=null ){
				seatArray[i].isDropped = false;
				seatArray[i].isOut = false;
				seatArray[i].dealValue = 0;
				playerArray.add(seatArray[i]);
			}
		}
		activePlayerArray = (ArrayList<UserSeatData>) playerArray.clone();
		
		texasExtension.trace("activePlayerArray length :"+activePlayerArray.size());
		
		extractJson(configData);
		
		currentPlayerTurnIndex = 0;
		if( taskHandle!=null ){
			taskHandle.cancel(true);
		}
		
		taskHandle = sfs.getTaskScheduler().scheduleAtFixedRate(new DistributeCardTimeout(), TIME_OUT_DISTRIBUTE_CARD, TIME_OUT_DISTRIBUTE_CARD, TimeUnit.SECONDS);
	}
	
	private void extractJson(String string)
	{
			
		JSONObject jsonObject = null;
		try {
			jsonObject = new JSONObject(string);
//			adsConfigData.version = jsonObject.getString();
			JSONArray winnerList = jsonObject.getJSONArray("winnerList");
			for( int i=0 ; i<=winnerList.length()-1 ; i++){
				JSONObject winner = winnerList.getJSONObject(i);
				String playerName = winner.getString("playerName");
				Double score = winner.getDouble("score");
				
				for( int j=0 ; j<=activePlayerArray.size()-1 ; j++ ){
					UserSeatData userSeatData = activePlayerArray.get(j);
					if( playerName.equals(userSeatData.user.getName()) ){
						userSeatData.winScore = score;
					}
				}
			}
		} catch (JSONException e) {
			texasExtension.trace("json error:"+e.getMessage());
			e.printStackTrace();
		}
	}
	
	public int currentCardTurn()
	{
		return currentCardTurn;
	}
	
	public int currentPlayerSeat()
	{
		if( currentPlayerTurnIndex==-1 ){
			return -1;
		}else{
			return activePlayerArray.get(currentPlayerTurnIndex).position;
		}
	}
	
	public int timeOutUserTurn()
	{
		return (int) (TIME_OUT_TURN*1000-(System.currentTimeMillis()-t));
	}
	
	public void userOut(User user)
	{
		for( int i=0 ; i<=activePlayerArray.size()-1 ; i++){
			if( activePlayerArray.get(i).user.getId() == user.getId() ){
				Boolean isCurrentTurn = false;
				if(activePlayerArray.get(i).user.getId() == activePlayerArray.get(currentPlayerTurnIndex).user.getId() ){
					isCurrentTurn=true;
				}
				
				activePlayerArray.get(i).isOut = true;
				activePlayerArray.remove(i);
				
				
				if( activePlayerArray.size() < 2){
		    		endGame();
		    		return;
				}
				
				if( isCurrentTurn ){
					taskHandle.cancel(true);
					gotoNextPlayer();
				}
				break;
			}
		}
	}
	
	public void userDeal(int _value, int userId)
	{
		texasExtension.trace("timeout... : "+ (System.currentTimeMillis()-t));
		if( activePlayerArray.get(currentPlayerTurnIndex)!=null &&
			userId != activePlayerArray.get(currentPlayerTurnIndex).user.getId() ){
			texasExtension.trace("not your turn... ");
			return;
		}
		
		taskHandle.cancel(true);
		
		ISFSObject resObj = new SFSObject();
		resObj.putInt(ExternalConst.VALUE, _value );
		resObj.putInt(ExternalConst.SIT_POSITION, currentPlayerTurnIndex ); 
		resObj.putInt(ExternalConst.TURN, currentCardTurn ); 
    	texasExtension.send(ExternalConst.USER_DEAL, resObj , texasExtension.getParentRoom().getUserList());
    	
    	// user droped card
    	if( _value==-1 ){
    		
    		activePlayerArray.get(currentPlayerTurnIndex).isDropped = true;
    		activePlayerArray.remove(currentPlayerTurnIndex);
    		currentPlayerTurnIndex--;
    		if(currentPlayerTurnIndex<0){
    			currentPlayerTurnIndex = activePlayerArray.size()-1;
    		}

    		texasExtension.trace(" _value:"+_value);
    		texasExtension.trace(" activePlayerArray.size():"+activePlayerArray.size());
    		
    	}else{
    		activePlayerArray.get(currentPlayerTurnIndex).dealValue += _value;
    	}
    	
    	if( activePlayerArray.size() < 2){
    		endGame();
    		return;
		}
    	
    	gotoNextPlayer();
	}
	
	private void gotoNextPlayer() {
		currentPlayerTurnIndex++;
    	if(currentPlayerTurnIndex>activePlayerArray.size()-1){
    		currentPlayerTurnIndex=0;
    		currentCardTurn++;
    		texasExtension.send(ExternalConst.START_NEW_ROUND_TURN, new SFSObject() , texasExtension.getParentRoom().getUserList());
    	}
    	
    	texasExtension.trace("currentCardTurn:"+currentCardTurn+" / "+MAX_CARD_TURN);
    	if( currentCardTurn > MAX_CARD_TURN){
    		texasExtension.trace(" currentCardTurn > MAX_CARD_TURN");
    		endGame();
    		return;
    	}
    	startCountTime();
	}

	private void endGame() {
		currentPlayerTurnIndex = -1;
		configData="";
		taskHandle.cancel(true);
		
		UserSeatData winnerPlayer = activePlayerArray.get(0);
		for( int i=0; i<=activePlayerArray.size()-1 ;i++){
			if( activePlayerArray.get(i).winScore > winnerPlayer.winScore ){
				winnerPlayer = activePlayerArray.get(i);
			}
		}
		String playerDeal = "[";
		for( int i=0 ; i<=playerArray.size()-1 ; i++){
			playerDeal += "{";
			playerDeal += "\"id\":\""+playerArray.get(i).fbuid+"\",";
			playerDeal += "\"money\":\""+playerArray.get(i).dealValue+"\"";
			playerDeal += "}";
			
			if( i!=playerArray.size()-1 ){
				playerDeal += ",";
			}
		}
		playerDeal += "]";
		
		UrlLoader urlLoaderEndGame = new UrlLoader();
		urlLoaderEndGame.addParam("action_option","saveTurn");
		urlLoaderEndGame.addParam("roomid",Integer.toString(texasExtension.getParentRoom().getId()) );
		urlLoaderEndGame.addParam("winnerid",winnerPlayer.fbuid);
		urlLoaderEndGame.addParam("playerdeal",playerDeal);
		
		texasExtension.trace("playerDeal:"+playerDeal);
		
		urlLoaderEndGame.signalComplete.add(new SignalEvent(){
			public void dispatch(Object...args)
			{
				texasExtension.trace("end game complete : "+args[0]);
			}
		});
		urlLoaderEndGame.signalError.add(new SignalEvent(){
			public void dispatch(Object...args)
			{
				texasExtension.trace("end game error : "+args[0]);
			}
		});
		urlLoaderEndGame.load(ExternalConst.ALL_CARD_URL);
		
		SFSObject sfsObj = new SFSObject();
		sfsObj.putInt(ExternalConst.SIT_POSITION, winnerPlayer.position);
		texasExtension.send(ExternalConst.END_TURN, sfsObj , texasExtension.getParentRoom().getUserList());
		
		taskHandle = sfs.getTaskScheduler().scheduleAtFixedRate(new EndTernTimeout(), TIME_OUT_END, TIME_OUT_END, TimeUnit.SECONDS);
	}

	private void startCountTime()
	{
		ISFSObject resObj = new SFSObject();
		resObj.putInt(ExternalConst.SIT_POSITION, activePlayerArray.get(currentPlayerTurnIndex).position );
    	texasExtension.send(ExternalConst.START_USER_TURN, resObj , texasExtension.getParentRoom().getUserList());
		
		t = System.currentTimeMillis();
		taskHandle = sfs.getTaskScheduler().scheduleAtFixedRate(new TurnTimeout(), TIME_OUT_TURN, TIME_OUT_TURN, TimeUnit.SECONDS);
	}
	
	
	
	
	private class DistributeCardTimeout implements Runnable
	{
		public void run()
		{
			taskHandle.cancel(true);
			startCountTime();
		}
	}

	private class TurnTimeout implements Runnable
    {
        public void run()
        {
        	userDeal(-1,activePlayerArray.get(currentPlayerTurnIndex).user.getId());
        }
    }
	
	private class EndTernTimeout implements Runnable
	{
		public void run()
		{
			signalEnd.dispatch();
		}
	}
}
