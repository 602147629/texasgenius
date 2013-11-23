package th.co.canon.theremember.core.view.player.playervdo 
{

	
	import ca.newcommerce.youtube.DataTracer;
	import ca.newcommerce.youtube.data.VideoData;
	import ca.newcommerce.youtube.events.VideoDataEvent;
	import ca.newcommerce.youtube.events.VideoFeedEvent;
	import ca.newcommerce.youtube.feeds.VideoFeed;
	import ca.newcommerce.youtube.webservice.YouTubeFeedClient;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	import net.area80.utils.LoaderUtils;
	
	import org.osflash.signals.Signal;
	
	
	
	
	
	
	
	public class YoutubePlayer extends EventDispatcher implements IPlayerVdo {   
		
		protected var _ws:YouTubeFeedClient;
		protected var _video:VideoData = null;
		
		private var isQualityPopulated:Boolean;
		private var isWidescreen:Boolean;
		private var vWidth:Number;
		private var vHeight:Number;
		private var player:Object;
		private var playerLoader:Loader;
		private var youtubeApiLoader:URLLoader;
		private var currentVideoId:String;
		private var buffer:Number=0;
		public static const DEFAULT_VIDEO_ID:String = "nbeQuV9wOfs";
		private static const PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
		private static const SECURITY_DOMAIN:String = "http://www.youtube.com";
		private static const CROSS_DOMAIN:String = "http://www.youtube.com/crossdomain.xml";
		private static const YOUTUBE_API_PREFIX:String = "http://gdata.youtube.com/feeds/api/videos/";
		private static const YOUTUBE_API_VERSION:String = "3";
		private static const YOUTUBE_API_FORMAT:String = "5";
		private static const WIDESCREEN_ASPECT_RATIO:String = "widescreen";
		private static const QUALITY_TO_PLAYER_WIDTH:Object = {small: 320,medium: 640,large: 854,hd720: 1280};
		private static const STATE_ENDED:Number = 0;
		private static const STATE_PLAYING:Number = 1;
		private static const STATE_PAUSED:Number = 2;
		private static const STATE_CUED:Number = 5;
		private static const STATE_UNSTARTED:Number = -1;
		private static const STATE_BUFFER:Number = 3;
		
		public var SIGNAL_FULLSCREEN:Signal = new Signal(Boolean);
		public var SIGNAL_COMPLETE:Signal = new Signal();
		private var _vdoSprite:Sprite;
		
		public function YoutubePlayer(w:uint=760,h:uint=428,$videoId:String=DEFAULT_VIDEO_ID)
		{
			vWidth=w;
			vHeight=h;
			currentVideoId = $videoId;
			_vdoSprite = new Sprite();
//			init(); //   "call init when function connect(); called"
		}
		private function init():void
		{
			//addEventListener(Event.REMOVED_FROM_STAGE,dispose);
			Security.allowDomain(SECURITY_DOMAIN);
			Security.loadPolicyFile(CROSS_DOMAIN);
			setupPlayerLoader();
			setupYouTubeApiLoader();
		}
		private function setupUi():void {
			_vdoSprite.addChild(playerLoader);
			SIGNAL_COMPLETE.dispatch();
		}
		public function loadAndPlay(id:String):void
		{
			currentVideoId = id;
		}
		private function setupPlayerLoader():void {
			playerLoader = new Loader();
			playerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, playerLoaderInitHandler);
			playerLoader.load(new URLRequest(PLAYER_URL));
		}
		
		private function playerLoaderInitHandler(event:Event):void {
			playerLoader.content.addEventListener("onReady", onPlayerReady);
			playerLoader.content.addEventListener("onError", onPlayerError);
			playerLoader.content.addEventListener("onStateChange",onPlayerStateChange);
			//playerLoader.content.addEventListener("onPlaybackQualityChange",onVideoPlaybackQualityChange);
		}
		
		private function setupYouTubeApiLoader():void {
			youtubeApiLoader = new URLLoader();
			youtubeApiLoader.addEventListener(IOErrorEvent.IO_ERROR,youtubeApiLoaderErrorHandler);
			youtubeApiLoader.addEventListener(Event.COMPLETE,youtubeApiLoaderCompleteHandler);
			getVideoData();
		}
		
		private function youtubeApiLoaderCompleteHandler(event:Event):void {
			var atomData:String = youtubeApiLoader.data;
			var atomXml:XML = new XML(atomData);
			var aspectRatios:XMLList = atomXml..*::aspectRatio;
			isWidescreen = aspectRatios.toString() == WIDESCREEN_ASPECT_RATIO;
			isQualityPopulated = false;
			getVideoData();
		}
		
		
		protected function getVideoData():void
		{	
			_ws = YouTubeFeedClient.getInstance();
			_ws.addEventListener(VideoDataEvent.VIDEO_INFO_RECEIVED, doVideoInfoReady);
			_ws.getVideo(currentVideoId);
		}
		protected function doVideoInfoReady(evt:VideoDataEvent):void
		{
			/*var video:VideoData = VideoData(evt.video);
			for(var i:* in video.rating){
				trace(i,video.rating[i]);
			}*/
			//DataTracer.traceVideo(evt.video);
		}
		public function playButtonClickHandler():void {
			if(player.getPlayerState()==-1){
				player.loadVideoById(currentVideoId);
			}else{
				player.playVideo();
			}
		}
		public function pauseButtonClickHandler():void {
			player.pauseVideo();
		}
		public function stopButtonClickHandler():void {
			player.stopVideo();
		}
		private function youtubeApiLoaderErrorHandler(event:IOErrorEvent):void {
			trace("Error making YouTube API request:", event);
		}
		
		private function onPlayerReady(event:Event):void {
			trace("Player Ready");
			player = playerLoader.content;
			player.setSize(vWidth, vHeight);
			setupUi();
			
			player.loadVideoById(currentVideoId);
			dispatchEvent( new PlayerVdoEvent( PlayerVdoEvent.CONNECTED ));
			//_onConnectedFunction();
		}
		
		private function onPlayerError(event:Event):void {
			trace("Player error:", Object(event).data);
		}
		
		private function onPlayerStateChange(event:Event):void {
			trace("State is", Object(event).data);
			switch (Object(event).data) {
				case STATE_UNSTARTED:
//					dispatchEvent( new PlayerVdoEvent( PlayerVdoEvent.BUFFER_EMPTY ));
					break;
				case STATE_ENDED:
					
					break;
				case STATE_PLAYING:
					dispatchEvent( new PlayerVdoEvent( PlayerVdoEvent.BUFFER_FULL));
					if(!isQualityPopulated) {
						populateQualityComboBox();
					}
					break;
				case STATE_PAUSED:
	
					break;
				case STATE_CUED:
					
					break;
				case STATE_BUFFER:
					dispatchEvent( new PlayerVdoEvent( PlayerVdoEvent.BUFFER_EMPTY ));
					break;
			}
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void {
			trace("Current video quality:", Object(event).data);
			resizePlayer(Object(event).data);
		}
		
		private function resizePlayer(qualityLevel:String):void {
			var newWidth:Number = QUALITY_TO_PLAYER_WIDTH[qualityLevel] || 640;
			var newHeight:Number;
			
			if (isWidescreen) {
				newHeight = newWidth * 9 / 16;
			} else {
				newHeight = newWidth * 3 / 4;
			}
		}
		
		private function populateQualityComboBox():void {
			isQualityPopulated = true;
			var qualities:Array = player.getAvailableQualityLevels();
			var currentQuality:String = player.getPlaybackQuality();
		}
		
		
		
		// interface controller
		
		public function get bytesLoaded():Number
		{
			buffer = player.getVideoBytesLoaded()/player.getVideoBytesTotal();
			return buffer;
		}
		
		public function connect():void
		{
			init();
		}
		public function get duration():Number
		{
			return player.getDuration();
		}
		
		public function get height():Number
		{
			return vHeight;
		}
		
		public function set height($value:Number):void
		{
			if(player){
				player.setSize(vWidth,$value);	
			}
		}
		
		public function pause():void
		{
			player.pauseVideo();	
		}
		
		public function play():void
		{
			playButtonClickHandler();	
		}
		
		public function seek($value:Number):void
		{
			if( $value > buffer ) $value=buffer-.1;
			if(player){
				player.seekTo( $value*player.getDuration());	
			}
		}
		
		public function get time():Number
		{
			return player.getCurrentTime();
		}
		
		public function get vdoHeight():Number
		{
			return vHeight;
		}
		
		public function get vdoSprite():Sprite
		{
			return _vdoSprite;
		}
		
		public function get vdoWidth():Number
		{
			return vWidth;
		}
		
		public function set volumn($value:Number):void
		{
			player.setVolume($value*100);
		}
		
		public function get width():Number
		{
			return vWidth;
		}
		
		public function set width($value:Number):void
		{
			if(player){
				player.setSize($value,vHeight);	
			}
		}
		
		public function setSize($width:Number, $height:Number):void
		{
			if(player){
				player.setSize($width,$height);
			}
			
		}
		
		public function get showAll():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function set showAll($value:Boolean):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function disconnect():void
		{
			if(playerLoader){
				LoaderUtils.clearLoader(playerLoader);
			}
			player.destroy();
		}
		public function get startBytes():Number{
			//			trace('Youtube startBytes:'+ (player.getVideoStartBytes()/player.getVideoBytesTotal()) );
			return player.getVideoStartBytes()/player.getVideoBytesTotal();
		}
	}
}

