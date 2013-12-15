package com.exitapplication.module.external;

import com.exitapplication.TexasExtension;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class UserSitEvent extends BaseClientRequestHandler {
	@Override
	public void handleClientRequest(User user, ISFSObject params)
	{
		TexasExtension gameExt = (TexasExtension) getParentExtension();
		gameExt.addUser(user,params.getInt(ExternalConst.SIT_POSITION) , 
				params.getUtfString(ExternalConst.FB_UID) ,
				params.getUtfString(ExternalConst.PLAYER_STATUS));
		
		
		/*try {
			gameExt.trace("User sit event"+ user.getId()+" room name:"+gameExt.getParentRoom().getName() );
			gameExt.getParentRoom().switchPlayerToSpectator(user);
			gameExt.trace("User error___"+user.isSpectator(gameExt.getParentRoom()) + " : "+ user.isSpectator() );
			gameExt.addUser(user);
		} catch (Exception e) {
			gameExt.trace(" error : "+e.getLocalizedMessage()+" , "+e.getMessage()+" , ");
			gameExt.addUserError(user,e.getMessage());
		}
		List<User> users = gameExt.getParentRoom().getUserList();
		for( int i=0 ; i<=users.size()-1 ; i++){
			gameExt.trace(" count["+i+"]"+users.get(i).isSpectator()+" : "+users.get(i).getName() );
		}*/
	}
}
