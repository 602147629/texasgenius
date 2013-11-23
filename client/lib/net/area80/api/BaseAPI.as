package net.area80.api
{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import net.area80.api.event.APIErrorEvent;


	[Event(type = "net.area80.api.event.APIErrorEvent", name = "error")]
	[Event(type = "flash.events.Event", name = "complete")]

	public class BaseAPI extends EventDispatcher
	{
		protected var _raw:String = "";
		protected var ldr:URLLoader;
		protected var uv:URLVariables;
		protected var uri:String;
		protected var method:String;
		protected var request:URLRequest;

		public var reloadIfFailed:Boolean = true;
		private const RELOAD_TIME_OUT:Number = 6000;
		private var timeoutReload:uint = 0;

		public function BaseAPI(uri:String, uv:URLVariables = null, method:String = "POST")
		{
			this.uri = uri;
			this.uv = uv;
			this.method = method;

			request = new URLRequest(this.uri);
			request.method = this.method;
			request.data = uv;
		}

		public function load():void
		{
			clearLoader();
			ldr = new URLLoader(request);
			ldr.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			ldr.addEventListener(Event.COMPLETE, loadCompleteHandler);
		}

		protected function loadCompleteHandler(event:Event):void
		{
			gotData(URLLoader(event.currentTarget).data);
		}

		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			if (reloadIfFailed) {
				trace("Fail to load "+uri+", reload...");
				timeoutReload = setTimeout(function():void {
					load();
				}, RELOAD_TIME_OUT);
				errorHandler("Can't connect to server, I am trying again.");
			} else {
				errorHandler("Can't connect to server, please try again.");
			}
		}

		public function get raw():String
		{
			return _raw;
		}

		protected function clearLoader():void
		{
			if (ldr) {
				clearTimeout(timeoutReload);
				ldr.close();
				ldr.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				ldr.removeEventListener(Event.COMPLETE, loadCompleteHandler);
				ldr = null;
			}
		}

		public function destroy():void
		{
			clearLoader();
		}

		protected function gotData(data:*):void
		{
			_raw = String(data);
			try {
				if (_raw=="") {
					throw new Error("Can't connect to server, please try again.");
				}
				var xmlData:XML = XML(data);
				if (xmlData.@success&&xmlData.@success=="false") {
					throw new Error(String(xmlData.description));
				}
				successHandler(xmlData);
			} catch (e:Error) {
				errorHandler(e.message);
			}
		}

		protected function successHandler(data:XML):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		protected function errorHandler(description:String):void
		{
			dispatchEvent(new APIErrorEvent(description));
		}
	}
}
