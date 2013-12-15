package com.exitapplication;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class UserUpdateHandler extends BaseClientRequestHandler
{
	@Override
	public void handleClientRequest(User user, ISFSObject params)
	{
		MyExtension gameExt = (MyExtension) getParentExtension();
		
		if (user.isPlayer())
		{
			
			
		}
		
		else
		{
		}
		ISFSObject resObj = new SFSObject();
		resObj.putUtfString(ExtensionType.TRACE, Integer.toString(gameExt.getParentRoom().getUserList().size()) );
		send(ExtensionType.TRACE , resObj, gameExt.getParentRoom().getUserList());
	}
}
