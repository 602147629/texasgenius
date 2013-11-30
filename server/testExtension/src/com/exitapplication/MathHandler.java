package com.exitapplication;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class MathHandler extends BaseClientRequestHandler {

	@Override
	public void handleClientRequest(User player, ISFSObject param) {
		
		int m1 = param.getInt("m1");
		int m2 = param.getInt("m2");
		ISFSObject rtn = new SFSObject();
		rtn.putInt("sum",m1+m2);
		
		MyExt parentExt = (MyExt) getParentExtension();
		parentExt.send("math", rtn, player);
		
	}

}
