package com.exitapplication.module.external;


import com.exitapplication.TexasExtension;
import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.exceptions.SFSException;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;

public class OnUserOut extends BaseServerEventHandler {
    @Override
	public void handleServerEvent(ISFSEvent event) throws SFSException
	{
		TexasExtension gameExt = (TexasExtension) getParentExtension();
		User user = (User)event.getParameter(SFSEventParam.USER);
		gameExt.trace("OnUserOut user.isSpectator():"+user.isSpectator());
		
		SFSObject sfsObject = new SFSObject();
		sfsObject.putInt(ExternalConst.USER_ID, user.getId());
		send(ExternalConst.ON_USER_OUT, sfsObject, gameExt.getParentRoom().getUserList());
		
		gameExt.removeUser(user);
	}
}
