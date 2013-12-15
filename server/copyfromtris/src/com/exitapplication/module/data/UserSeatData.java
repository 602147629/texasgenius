package com.exitapplication.module.data;

import com.smartfoxserver.v2.entities.User;

public class UserSeatData {
	public User user;
	public int position;
	public int dealValue = 0;
	public boolean isDropped = false;
	public boolean isOut = false;

	public UserSeatData(User user, int position ){
		this.user = user;
		this.position = position;
	}
}
