package net.area80.ui
{
	import com.adobe.serialization.adobejson.AdobeJSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.Signal;

	public class FBLoader
	{
		private static const GRAPH_PATH:String = "https://graph.facebook.com/";
		public static const USER_DATA:String = "me";
		public static const ALBUM:String = "me/albums";
		public static const PHOTO:String = "/photos";
		
		public var SIGNAL_COMPLETE:Signal;
		public var SIGNAL_ERROR:Signal;
		
		private var dataFolder:String;
		private var access_token:String;
		private var alumId:String;
		public function FBLoader($dataFolder:String,$access_token:String,$alumId:String="")
		{
			dataFolder = $dataFolder;
			access_token = $access_token;
			alumId = $alumId;
			
			SIGNAL_COMPLETE = new Signal(Object);
			SIGNAL_ERROR = new Signal(Object);
			
			if($dataFolder && $access_token)
				load();
		}
		public function load():void
		{
			var url:String = GRAPH_PATH+alumId+dataFolder+"?access_token="+access_token;
			trace(">> FB Loading = "+url);
			var urlLoader:URLLoader = new URLLoader(new URLRequest(url));
			urlLoader.addEventListener(Event.COMPLETE,loaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,error);
		}
		private function loaded(e:Event):void
		{
			var data:String = e.target.data;
			trace(">> FB Loaded = "+data);
			SIGNAL_COMPLETE.dispatch(AdobeJSON.decode(data));
		}
		/**
		 * If cannot connect to facebook
		 */		
		private function error(e:Event):void
		{
			trace(">> ERROR CONNECTION Please checking your access token");
			var data:String = e.target.data;
			trace(">> FB Loaded = "+data);
			SIGNAL_ERROR.dispatch(data);
		}
	}
}