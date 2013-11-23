package net.area80.facebook.graph
{

	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import net.area80.facebook.graph.vo.*;
	import net.area80.utils.FileActivity;

	/**
	 * Dispatchs when user complete a request.
	 */
	[Event(name = "complete", type = "net.area80.facebook.graph.FBGraphEvent")]

	public class FBGraphRequest extends EventDispatcher
	{


		private var token:String;
		private const graphuri:String = "https://graph.facebook.com/";

		private static const IOErrorResponse:FBError = new FBError("Can't connect to facebook, please try again.", "IOErrorException", "000");
		private static const InternalServerErrorResponse:FBError = new FBError("Can't connect to facebook, please try again.", "RequestErrorException", "001");


		public function FBGraphRequest(token:String)
		{
			this.token = token;
		}

		private function api(api:String, callBack:Function, params:Object = null, method:String = URLRequestMethod.GET):URLLoader
		{
			var uri:String = graphuri + api;
			var variables:URLVariables = getVariables(params);

			return FileActivity.loadJSON(uri, callBack, variables, method);
		}

		private function getVariables(params:Object):URLVariables
		{
			if (!params) {
				params = new Object();
			}
			params["access_token"] = token;

			var res:URLVariables = new URLVariables();
			for (var key:String in params) {
				res[key] = params[key];
			}
			return res;

		}

		protected function dispatchEventObject(response:FBResponse, method:String):void
		{
			dispatchEvent(new FBGraphEvent(FBGraphEvent.COMPLETE, response, method));
		}

		public function getFriendLists(limit:int = 500, offset:int = 0, onePage:Boolean = false, listData:FBFriendListData = null):void
		{
			var ldr:URLLoader = api("me/friends/", function(res:Object):void
			{
				if (res.error) {
					dispatchEventObject(new FBError(res.error.message, res.error.type, res.error.code), "getFriendLists");
				} else if (res.data) {
					if (!listData) {
						listData = new FBFriendListData();
					}
					for (var i:int = 0; i < res.data.length; i++) {
						var friend:FBFriend = new FBFriend(res.data[i].id, res.data[i].name);
						listData.data.push(friend);
					}
					if (onePage) {
						dispatchEventObject(listData, "getFriendLists");
					} else {
						if (res.paging && res.paging.next) {
							getFriendLists(limit, offset + limit, false, listData);
						} else {
							dispatchEventObject(listData, "getFriendLists");
						}
					}

				} else {
					dispatchEventObject(InternalServerErrorResponse.clone(), "getFriendLists");
				}
			}, {limit:limit, offset:offset}, URLRequestMethod.GET);
			ldr.addEventListener(IOErrorEvent.IO_ERROR, function():void
			{
				dispatchEventObject(IOErrorResponse.clone(), "getFriendLists");
			});

		}

	}
}
