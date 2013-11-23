package net.area80.facebook
{
	import com.adobe.serialization.adobejson.AdobeJSON;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;
	
	//FacebookConnectData for get facebook user data
	//
	public class FacebookConnectData extends Sprite
	{
		private static const GRAPH_PATH:String = "https://graph.facebook.com/";
		public var _access_token:String;
		public var SIGNAL_USERS_COMPLETE:Signal;
		public var SIGNAL_ALBUMS_COMPLETE:Signal;
		public var SIGNAL_PHOTOS_COMPLETE:Signal;
		public var SIGNAL_PHOTOSCOVER_COMPLETE:Signal;
		
		public function FacebookConnectData(token:String)
		{
			_access_token = token;
			SIGNAL_USERS_COMPLETE = new Signal(Object);
			SIGNAL_ALBUMS_COMPLETE = new Signal(Object);
			SIGNAL_PHOTOS_COMPLETE = new Signal(Object);
			SIGNAL_PHOTOSCOVER_COMPLETE = new Signal(Object);
		}
		public function loadFacebookUser(token:String):void
		{
			_access_token = token;
			var userUrl:String = GRAPH_PATH+"me?access_token="+_access_token;
			var facebookRequest:URLRequest = new URLRequest(userUrl);
			var loadURL:URLLoader = new URLLoader();
			loadURL.addEventListener(Event.COMPLETE,onLoadFacebookUser);
			try{
				loadURL.load(facebookRequest);
			}catch(facebookErr:Error){
				trace(facebookErr.message);
			}
		}
		private function onLoadFacebookUser(e:Event):void{
			var _data:Object = AdobeJSON.decode(e.target.data);
			SIGNAL_USERS_COMPLETE.dispatch(_data);
			loadFacebookAlbums();
		}
		public function loadFacebookAlbums():void
		{
			var userUrl:String = GRAPH_PATH+"me/albums?access_token="+_access_token;
			var facebookRequest:URLRequest = new URLRequest(userUrl);
			var loadURL:URLLoader = new URLLoader();
			loadURL.addEventListener(Event.COMPLETE,onLoadFacebookAlbums);
			try{
				loadURL.load(facebookRequest);
			}catch(facebookErr:Error){
				trace(facebookErr.message);
			}
		}
		private function onLoadFacebookAlbums(e:Event):void{
			var _data:Object = AdobeJSON.decode(e.target.data);
			SIGNAL_ALBUMS_COMPLETE.dispatch(_data);
		}
		public function loadFacebookPhotos(aid:String):void
		{
			var userUrl:String = GRAPH_PATH+aid+"/photos?access_token="+_access_token;
			var facebookRequest:URLRequest = new URLRequest(userUrl);
			var loadURL:URLLoader = new URLLoader();
			loadURL.addEventListener(Event.COMPLETE,onLoadFacebookPhotos);
			try{
				loadURL.load(facebookRequest);
			}catch(facebookErr:Error){
				trace(facebookErr.message);
			}
		}
		private function onLoadFacebookPhotos(e:Event):void{
			var _data:Object = AdobeJSON.decode(e.target.data);
			SIGNAL_PHOTOS_COMPLETE.dispatch(_data);
		}
		public function loadCoverPhoto(aid:String):void{
			var userUrl:String = GRAPH_PATH+aid+"/picture?access_token="+_access_token;
			var facebookRequest:URLRequest = new URLRequest(userUrl);
			var loadURL:URLLoader = new URLLoader();
			loadURL.addEventListener(Event.COMPLETE,onLoadFacebookCoverAlbum);
			try{
				loadURL.load(facebookRequest);
			}catch(facebookErr:Error){
				trace(facebookErr.message);
			}
		}
		private function onLoadFacebookCoverAlbum(e:Event):void
		{
			var _data:Object = AdobeJSON.decode(e.target.data);
			SIGNAL_PHOTOSCOVER_COMPLETE.dispatch(_data);
		}
	}
}