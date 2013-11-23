package net.pirsquare.m
{
	import flash.display.Stage;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoEvent;
	import flash.events.VideoEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osflash.signals.Signal;

	public class StageVideoUtil
	{
		public function StageVideoUtil()
		{
			instance = this;
		}
		public static var instance:StageVideoUtil;
		
		private static var _stage:Stage;
		private static var _uri:String;
		private static var nc:NetConnection;
		private static var ns:NetStream;
		private static var sv:StageVideo;
		private static var rc:Rectangle;
		private static var videoRect:Rectangle = new Rectangle(0, 0, 0, 0);
		
		public static var netStatusSignal:Signal;
		
		public static function initStage(stage:Stage):void
		{
			_stage = stage;
			
			_clientObject = new Object();
			_clientObject.onMetaData=onMetaData;
			_clientObject.onCuePoint=onCuePoint;
			_clientObject.onPlayStatus=onPlayStatus;
		}
		
		public static function onCuePoint( info:Object ) : void { }
		public static function onPlayStatus( info:Object ) : void { }
		public static function onMetaData( info:Object):void
		{
			trace(info);
		}
		
		private static var _clientObject:Object;
		public static var isPlay:Boolean = false;
		private static var video:Video;
		
		public static function play(uri:String):void
		{
			netStatusSignal = new Signal(String);
			isPlay = true;
			_uri = uri;
			
			// Connections
			nc = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			ns.client = _clientObject;
			// Screen
			video = new Video();
			video.smoothing = true;
			video.width = 960;
			video.height = 640;
			//-stage video
			
			sv = _stage.stageVideos[0];
			sv.addEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);
			sv.attachNetStream(ns);
			
			_stage.addChildAt(video,0);
			
			ns.play(_uri);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */		
		private static function onNetStatus(event:NetStatusEvent):void
		{
			netStatusSignal.dispatch(event.info.code);
		}
		
		public static function stop():void
		{
			netStatusSignal.removeAll();
			netStatusSignal =null;
			
			isPlay = false;
			
			//video.attachNetStream(ns);
			
			video.clear();
			video.removeEventListener(VideoEvent.RENDER_STATE, videoStateChange);
			
			if(video.parent)
				video.parent.removeChild(video);
				
			video = null;
			
			
			ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			ns.pause();
			/*ns.dispose();
			ns.close();
			ns.dispose();
			ns = null;
			*/
			nc.close();
			nc = null;
		
			sv.removeEventListener(StageVideoEvent.RENDER_STATE, stageVideoStateChange);
			sv = null;
			
			_stage.stageVideos[0] = null;
		}
		
		private static function videoStateChange(event:VideoEvent):void
		{	
			resize();
		}
		/**
		 * 
		 * @param event
		 * 
		 */		
		private static function stageVideoStateChange(event:StageVideoEvent):void
		{	
			resize();
		}
		
		/**
		 * 
		 * 
		 */		
		private static function resize ():void
		{	
				// Get the Viewport viewable rectangle
				rc = getVideoRect(sv.videoWidth, sv.videoHeight);
				// set the StageVideo size using the viewPort property
				sv.viewPort = rc;
			
		}
		
		/**
		 * 
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */		
		private static function getVideoRect(width:uint, height:uint):Rectangle
		{	
			var videoWidth:uint = width;
			var videoHeight:uint = height;
			//var scaling:Number = Math.min ( _stage.stageWidth / videoWidth, _stage.stageHeight / videoHeight );
			var scaling:Number = Math.min ( Config.DEVICE_WIDTH / videoWidth, Config.DEVICE_HEIGHT / videoHeight )/Config.deviceScale;
			
			videoWidth *= scaling, videoHeight *= scaling;
			
			var posX:uint = (Config.DEVICE_WIDTH/Config.deviceScale - videoWidth >> 1);
			var posY:uint = _stage.stageHeight - videoHeight >> 1;
			
			videoRect.x = Config.OffScreenMargin;
			videoRect.y = posY;
			videoRect.width = videoWidth;
			videoRect.height = videoHeight;
			
			return videoRect;
		}
	}
}