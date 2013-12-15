package com.exitapplication;

import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class MyExtension extends SFSExtension {

	@Override
	public void init() {
		this.addRequestHandler("math", MathHandler.class);
		this.addRequestHandler("test", TestExt.class);
		
		addEventHandler(SFSEventType.USER_DISCONNECT, UserUpdateHandler.class);
	    addEventHandler(SFSEventType.USER_LEAVE_ROOM, UserUpdateHandler.class);
	    addEventHandler(SFSEventType.USER_JOIN_ROOM, UserUpdateHandler.class);
		
	}

	public void startGame() {
		
	}

}
