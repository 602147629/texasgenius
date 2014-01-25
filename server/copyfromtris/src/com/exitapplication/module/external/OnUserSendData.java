package com.exitapplication.module.external;

import com.exitapplication.TexasExtension;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class OnUserSendData extends BaseClientRequestHandler {
    @Override
	public void handleClientRequest(User user, ISFSObject params)
	{
		TexasExtension gameExt = (TexasExtension) getParentExtension();
		
		ISFSObject resObj = new SFSObject();
		resObj.putInt(ExternalConst.USER_ID, user.getId() );
		resObj.putUtfString( ExternalConst.VALUE , params.getUtfString(ExternalConst.VALUE) );
		gameExt.send(ExternalConst.DATA, resObj , gameExt.getParentRoom().getUserList());
	}
}
