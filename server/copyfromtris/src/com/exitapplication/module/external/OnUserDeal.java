package com.exitapplication.module.external;

import com.exitapplication.TexasExtension;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class OnUserDeal extends BaseClientRequestHandler {
	@Override
	public void handleClientRequest(User user, ISFSObject params)
	{
		TexasExtension gameExt = (TexasExtension) getParentExtension();
		gameExt.userDeal(params.getInt(ExternalConst.VALUE), user.getId());
	}
}