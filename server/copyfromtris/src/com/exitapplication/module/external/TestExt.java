package com.exitapplication.module.external;


import com.exitapplication.TexasExtension;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class TestExt extends BaseClientRequestHandler {
	@Override
	public void handleClientRequest(User user, ISFSObject params)
	{
		TexasExtension gameExt = (TexasExtension) getParentExtension();
		gameExt.trace(params.getUtfString("data"));
	}
}
