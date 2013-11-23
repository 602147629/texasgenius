package net.area80.facebook
{

	import com.facebook.graph.Facebook;
	import com.facebook.graph.FacebookMobile;

	import flash.events.EventDispatcher;

	import net.area80.model.FacebookUser;

	public class FacebookMobileUser extends EventDispatcher
	{
		private static var _instance:FacebookMobileUser;
		private static var isInitial:Boolean = false;

		public var appId:String;
		public var permissions:Array;
		private var user:FacebookUser;

		public static function forceLogout(callBack:Function = null):void
		{
			FacebookMobile.logout(callBack);
			if (_instance)
				_instance.logout();
		}

		public static function isInitialize():Boolean
		{
			return isInitial;
		}

		public static function initialize(appId:String, permissions:Array, callback:Function = null):FacebookMobileUser
		{
			isInitial = false;
			_instance = new FacebookMobileUser(appId, permissions, callback);

			return _instance;
		}

		public static function getInstance():FacebookMobileUser
		{
			return _instance;
		}

		public function FacebookMobileUser(appId:String, permissions:Array, callback:Function = null)
		{
			this.appId = appId;
			this.permissions = permissions;

			FacebookMobile.init(appId, function(cb:Object, cberror:Object):void
			{
				FacebookMobileUser.isInitial = true;
				_handleLoginCallback(cb, cberror);
				if (callback is Function) {
					callback();
					callback = null;
				}
			});
		}

		public function logout():void
		{
			setUser(null);
		}

		/**
		 * Internal use to set facebook user via login handler
		 * @internal
		 * @param cb
		 * @param cberror
		 *
		 */
		public function _handleLoginCallback(cb:Object, cberror:Object):void
		{
			if (cb) {
				setUser(new FacebookUser(cb.user.name, cb.user.id, cb.accessToken));
				user.raw = cb.user;
			} else {
				setUser(null);
			}
		}

		public function setUser(user:FacebookUser):void
		{
			this.user = user;
		}

		public function isConnected():Boolean
		{
			return (user!=null);
		}

		public function getUser():FacebookUser
		{
			return user;
		}
	}
}
