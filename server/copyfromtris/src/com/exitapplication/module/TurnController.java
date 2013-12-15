package com.exitapplication.module;

import java.util.ArrayList;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

import com.exitapplication.TexasExtension;
import com.exitapplication.lib.signal.Signal;
import com.exitapplication.module.data.UserSeatData;
import com.exitapplication.module.external.ExternalConst;
import com.smartfoxserver.v2.SmartFoxServer;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class TurnController {
	final private int TIME_OUT_DISTRIBUTE_CARD = 5; 
	final private int TIME_OUT_TURN = 10; 
	final private int MAX_CARD_TURN = 3; 
	
	public Signal signalEnd = new Signal();
	
	private TexasExtension texasExtension;
	private ArrayList<UserSeatData> playerArray = new ArrayList<UserSeatData>();
	private ArrayList<UserSeatData> activePlayerArray = new ArrayList<UserSeatData>();
	private int currentPlayerTurnIndex = 0;
	private int currentCardTurn = 0;
	
	
	private SmartFoxServer sfs = SmartFoxServer.getInstance();
	private ScheduledFuture<?> taskHandle;
	private long t;

	public TurnController(TexasExtension texasExtension) {
		this.texasExtension = texasExtension;
	}

	@SuppressWarnings("unchecked")
	public void start(String configData, UserSeatData[] seatArray) 
	{
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
		
		currentPlayerTurnIndex = 0;
		if( taskHandle!=null ){
			taskHandle.cancel(true);
		}
		
		taskHandle = sfs.getTaskScheduler().scheduleAtFixedRate(new DistributeCardTimeout(), TIME_OUT_DISTRIBUTE_CARD, TIME_OUT_DISTRIBUTE_CARD, TimeUnit.SECONDS);
	}
	
	public void userOut(User user)
	{
		for( int i=0 ; i<=activePlayerArray.size()-1 ; i++){
			if( activePlayerArray.get(i).user.getId() == user.getId() ){
				
				activePlayerArray.get(i).isOut = true;
				activePlayerArray.remove(i);
				
				
				if( activePlayerArray.size() < 2){
		    		endGame();
		    		return;
				}
				
				if(activePlayerArray.get(i).user.getId() == activePlayerArray.get(currentPlayerTurnIndex).user.getId() ){
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
		taskHandle.cancel(true);
		texasExtension.send(ExternalConst.END_TURN, new SFSObject() , texasExtension.getParentRoom().getUserList());
		signalEnd.dispatch();
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
        	userDeal(0,activePlayerArray.get(currentPlayerTurnIndex).user.getId());
        }
    }
}
