package com.exitapplication.module.data;

import com.smartfoxserver.v2.entities.User;

public class UserSeatData {
	public User user;
	public String fbuid;
	public int position;
	public String playerStatus;
	public int dealValue = 0;
	public boolean isDropped = false;
	public boolean isOut = false;

	public UserSeatData(User user, String fbuid, int position, String playerStatus ){
		this.user = user;
		this.fbuid = fbuid;
		this.position = position;
		this.playerStatus = playerStatus;
	}
}
