package com.exitapplication;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class TestExt extends BaseClientRequestHandler {
	@Override
	public void handleClientRequest(User user, ISFSObject params)
	{
		MyExtension gameExt = (MyExtension) getParentExtension();
		
		ISFSObject resObj = new SFSObject();
		resObj.putInt("t", 2);
		send("test", resObj, gameExt.getParentRoom().getUserList());
	}
}
