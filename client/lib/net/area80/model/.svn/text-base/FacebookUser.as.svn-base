package net.area80.model
{

	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;

	import net.area80.utils.FileActivity;

	public class FacebookUser
	{
		public var accessToken:String;
		public var fbuid:String;
		public var name:String;
		public var raw:Object;
		public var custom:Object = new Object();

		public function FacebookUser(name:String, fbuid:String, accessToken:String)
		{
			this.name = name;
			this.fbuid = fbuid;
			this.accessToken = accessToken;
		}

		public static function createFromExchangeToken(url:String, successCallBack:Function, errorCallback:Function, ioErrorCallback:Function = null):void
		{
			var ldr:URLLoader = FileActivity.loadXML(url, function(data:XML):void
			{
				if (data.@success=="true") {
					successCallBack(new FacebookUser(data.name.toString(), data.fbuid.toString(), data.accessToken.toString()));

				} else {
					errorCallback(data.description.toString());
				}
			});
			ldr.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
			{
				if (ioErrorCallback is Function) {
					ioErrorCallback(e);
				}
			});
		}
	}
}
