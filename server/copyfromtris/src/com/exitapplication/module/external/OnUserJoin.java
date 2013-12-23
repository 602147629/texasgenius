package com.exitapplication.module.external;

import java.util.ArrayList;

import com.exitapplication.TexasExtension;
import com.exitapplication.module.data.UserSeatData;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.exceptions.SFSException;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;

public class OnUserJoin extends BaseServerEventHandler {

	@Override
	public void handleServerEvent(ISFSEvent event) throws SFSException 
	{
		TexasExtension gameExt = (TexasExtension) getParentExtension();
		User user = (User)event.getParameter(SFSEventParam.USER);
		
		
		
		String playerData = "";
		String turnConfigData = "\"\"";
		int currentSeat = -1;
		int currentTurn = -1;
		int timeRemain = -1;
		if( gameExt.currentState==gameExt.WAIT_PLAYER_STATE || gameExt.currentState==gameExt.START_LOAD_CONFIG_STATE){
			
		}else if(gameExt.currentState==gameExt.START_TURN_STATE){
			currentSeat = gameExt.turnController.currentPlayerSeat();
			currentTurn = gameExt.turnController.currentCardTurn();
			timeRemain = gameExt.turnController.timeOutUserTurn();
		}
		
		ArrayList<UserSeatData> playerArray = gameExt.getUserSitDatas();
		for( int i=0 ; i<=playerArray.size()-1 ; i++ ){
			UserSeatData userSeatData = playerArray.get(i);
			playerData+="{";
			playerData+="		\"fbuid\":\""+userSeatData.fbuid+"\",";
			playerData+="		\"position\":\""+userSeatData.position+"\",";
			playerData+="		\"dealValue\":\""+userSeatData.dealValue+"\",";
			playerData+="		\"playerStatus\":"+userSeatData.playerStatus+",";
			playerData+="		\"isDropped\":\""+userSeatData.isDropped+"\"";
			playerData+="}";
			
			if( i!=playerArray.size()-1){
				playerData+=",";
			}
		}
		turnConfigData = gameExt.configData;
		if( turnConfigData == ""){
			turnConfigData = "\"\"";
		}
		
		String startConfigData = "{ \"playerData\":["+playerData+"] ,";
		startConfigData += " \"turnConfigData\":"+turnConfigData+" }";
		
		trace("startConfigData:"+startConfigData);
		
		SFSObject sfsObject = new SFSObject();
		sfsObject.putInt(ExternalConst.SIT_POSITION, currentSeat);
		sfsObject.putInt(ExternalConst.TURN, currentTurn);
		sfsObject.putInt(ExternalConst.TIME, timeRemain);
		sfsObject.putUtfString(ExternalConst.CONFIG_DATA, startConfigData);
		send(ExternalConst.SEND_TURN_DATA, sfsObject, user);
	}

}
