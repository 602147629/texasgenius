package EXIT.engine.player.playervdo
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getTimer;

	public class VdoNetStream extends EventDispatcher implements IPlayerVdo
	{
		//-- NET CONNECTION ---
		private var url:String;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var _bytesTotal:Number = 0;
		private var _duration:Number;

		//-- VDO---
		private var video:Video;
		private var vdoSound:SoundTransform;
		private var _vdoSprite:Sprite;
		private var _vdoWidth:Number;
		private var _vdoHeight:Number;
		private var vdoRatio:Number;

		//--- status --
		private var isConnected:Boolean = false;
		private var buffer:Number = 0;
		private var _showAll:Boolean = false;


		public function VdoNetStream($url:String)
		{
			url = $url;
			initVdo();
		}

		protected function initVdo():void
		{
			video = new Video();
			_vdoSprite = new Sprite();
			vdoSprite.addChild(video);

			nc = new NetConnection();
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(e:Event):void {trace(' :::::: AsyncErrorEvent.ASYNC_ERROR:::::: ')});
			nc.connect(null);

			ns = new NetStream(nc);
			ns.bufferTime = 5;
			ns.client = this;
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(e:Event):void {trace(' :::::: AsyncErrorEvent.ASYNC_ERROR:::::: ')});

			video.attachNetStream(ns);
			video.smoothing = false;
		}

		public function onXMPData(e:* = null):void
		{
			trace('_______ onXMPData _____ ');
			for (var i:* in e.info) {
				trace(e.info[i]+' : '+i);
			}
			trace('_________________________');
		}

		public function onPlayStatus(infoObject:Object):void
		{
			trace("NetStream.onPlayStatus called: ("+getTimer()+" ms)");
			for (var prop:* in infoObject) {
				trace("\t"+prop+":\t"+infoObject[prop]);
			}
		}

		protected function netStatusHandler(e:NetStatusEvent):void
		{
			if (e.info.code=="NetStream.FileStructureInvalid") {
				trace("The MP4's file structure is invalid.");
			} else if (e.info.code=="NetStream.NoSupportedTrackFound") {
				trace("The MP4 doesn't contain any supported tracks");
			} else if (e.info.code=="NetStream.Seek.InvalidTime") {
				ns.seek(e.info.details);
			} else if (e.info.code=="NetStream.Buffer.Full") {
//				trace('dispatch bf full');
				dispatchEvent(new PlayerVdoEvent(PlayerVdoEvent.BUFFER_FULL));
			} else if (e.info.code=="NetStream.Buffer.Empty") {
//				trace('dispatch bf empty');
				dispatchEvent(new PlayerVdoEvent(PlayerVdoEvent.BUFFER_EMPTY));
			} else if (e.info.code=="NetStream.Play.StreamNotFound") {
				dispatchEvent(new PlayerVdoEvent(PlayerVdoEvent.NOT_FOUND));
			} else if (e.info.code=="NetStream.Play.Stop") {
				trace('===== END VDO =====');
				dispatchEvent(new PlayerVdoEvent(PlayerVdoEvent.END));
			}

			trace('=========== NET STREAM EVENT ===========');
			for (var i:* in e.info) {
				trace(e.info[i]+' : '+i);
			}
			trace('========================================');
		}

		public function onMetaData($info:Object):void
		{
			trace('++++++++++++++++ onMetaData ++++++++++++++++');
			for (var propName:String in $info) {
				trace(propName+" = "+$info[propName]);
			}
			trace('+++++++++++++++++++++++++++++++++++++++++++++');
			//-- keep info ---
			_vdoWidth = $info.width; // ? $info.width:1280;
			_vdoHeight = $info.height; // ? $info.heigh:720;
			vdoRatio = vdoWidth/vdoHeight;
			_duration = $info.duration;
			_bytesTotal = ns.bytesTotal;

			dispatchEvent(new PlayerVdoEvent(PlayerVdoEvent.CONNECTED));
		}


		public function connect():void
		{
			isConnected = true;
			ns.play(url);
//			trace(' connecting buffer is empty.');
			dispatchEvent(new PlayerVdoEvent(PlayerVdoEvent.BUFFER_EMPTY));
		}

		public function disconnect():void
		{
			ns.close();
		}

		public function play():void
		{
			if (isConnected) {
				ns.resume();
			}
		}

		public function pause():void
		{
			ns.pause();
		}

		public function seek($value:Number):void
		{
			if ($value>buffer)
				$value = buffer-.1;
			ns.seek($value*duration);
		}

		public function get startBytes():Number
		{
			return 0;
		}

		public function get bytesLoaded():Number
		{
			buffer = ns.bytesLoaded/_bytesTotal;
			return ns.bytesLoaded/_bytesTotal;
		}

		public function get duration():Number
		{
			return _duration;
		}

		public function get time():Number
		{
			return ns.time;
		}

		public function get vdoSprite():Sprite
		{
			return _vdoSprite;
		}

		public function get vdoHeight():Number
		{
			return _vdoHeight;
		}

		public function get vdoWidth():Number
		{
			return _vdoWidth;
		}


		public function set volumn($value:Number):void
		{
			vdoSound = ns.soundTransform;
			vdoSound.volume = $value;
			ns.soundTransform = vdoSound;
		}

		public function get showAll():Boolean
		{
			return _showAll;
		}

		public function set showAll($value:Boolean):void
		{
			_showAll = $value;
		}

		public function setSize($width:Number, $height:Number):void
		{
			var ratio:Number = $width/$height;
			var scale:Number;
			var isFitWidth:Boolean = ratio<vdoRatio;
			isFitWidth = showAll?!isFitWidth:isFitWidth; //if showAll, use another axis to fit to screen
			if (isFitWidth) {
				//set value is wider vdo, FIT WIDTH
				video.width = $width;
				scale = video.width/vdoWidth;
				video.height = vdoHeight*scale;
				video.x = 0;
				video.y = ($height-video.height)/2;
			} else {
				//set value is higher vdo, FIT HEIGHT
				video.height = $height;
				scale = video.height/vdoHeight;
				video.width = vdoWidth*scale;
				video.y = 0;
				video.x = ($width-video.width)/2;
			}
		}

		public function get width():Number
		{
			return vdoSprite.width;
		}

		public function get height():Number
		{
			return vdoSprite.height;
		}

		public function set width($value:Number):void
		{
			setSize($value, vdoSprite.height);
		}

		public function set height($value:Number):void
		{
			setSize(vdoSprite.width, $value);
		}

	}
}
