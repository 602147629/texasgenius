package EXIT.engine.player
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import net.area80.utils.DrawingUtils;
	
	import org.osflash.signals.Signal;
	
	import EXIT.engine.player.playerskin.PlayerSkin;
	import EXIT.engine.player.playerskin.PlayerSkinEvent;
	import EXIT.engine.player.playervdo.IPlayerVdo;
	import EXIT.engine.player.playervdo.PlayerVdoEvent;
	import EXIT.engine.player.asset.LoadingBuffer;
	
	public class PlayerController extends Sprite
	{
		public var signalEvent						:Signal;
		public static const TOGGLE_FULLSCREEN		:String = 'togglefullscreen';
		
		private var player							:IPlayerVdo;
		private var skin							:PlayerSkin;
		private var loading							:LoadingBuffer;
		//-- vdo--
		private var vdo								:Sprite;
		private var bg								:Sprite;
		
		
		//-- property --
		private var thumbUrl						:String;
		private var bufferTimer						:Timer;
		private var progressTimer					:Timer;
		private var isPeriodDoubleClick				:Boolean=false;
		private var timeoutDoubleClick				:uint=0;
		
		private var vdoLoadedAll					:Boolean=false;
		private var isPlay							:Boolean=true;
		private var isSeeking						:Boolean=false;
		private var isConnected						:Boolean=false;
		
		//-- variable ---
		private var tempIsPlay						:Boolean=false;
		private var _width							:Number;
		private var _height							:Number;
		
		// hide skin property
		private var _autoHideSkin					:Boolean=true
		private var timeoutHideSkin					:uint=0;
		private var isOverSkin						:Boolean=false;
		private var isHideSkin						:Boolean=false;
		
		public function PlayerController( $player:IPlayerVdo , $skin:PlayerSkin , $width:Number=550 , $height:Number=400 , $thumbUrl:String='' , $autoHideSkin:Boolean=false)
		{
			super();
			player=$player;
//			player.showAll = true;
			skin=$skin;
			_width = $width;
			_height = $height;
			thumbUrl = $thumbUrl;
			_autoHideSkin = $autoHideSkin;
			signalEvent = new Signal(String);
			
			bg = DrawingUtils.getRectSprite($width,$height);
			bg.addEventListener(MouseEvent.CLICK,bgClick);
			bg.buttonMode=true;
			addChild(bg);
			
			if(_autoHideSkin){
				skin.addEventListener(MouseEvent.ROLL_OVER , overSkin);
				skin.addEventListener(MouseEvent.ROLL_OUT , outSkin);
				this.addEventListener(MouseEvent.MOUSE_MOVE , updateShowSkin );
				updateShowSkin();
			}
			
			vdo=player.vdoSprite;
			vdo.mouseEnabled=false;
			vdo.mouseChildren=false;
			
			addChild(skin);
			
			loading = new LoadingBuffer();
			addChild(loading);
			
			bufferTimer = new Timer(1000);
			progressTimer = new Timer(500);
			progressTimer.addEventListener(TimerEvent.TIMER,updateProgress);
			bufferTimer.addEventListener(TimerEvent.TIMER,updateBuffer);
			addEventListener(Event.ADDED_TO_STAGE , initialize);
		}
		
		protected function initialize(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , initialize);
			addEventListener(Event.REMOVED_FROM_STAGE , dispose);
			
			skin.addEventListener(PlayerSkinEvent.PLAY,play);
			skin.addEventListener(PlayerSkinEvent.PAUSE,pause);
			skin.addEventListener(PlayerSkinEvent.SEEK,seek);
			skin.addEventListener(PlayerSkinEvent.TOGGLE_FULLSCREEN,toggleFullscreen);
			skin.addEventListener(PlayerSkinEvent.VOLUMN,volumn);
			
			initVDO();
			setSize(width,height);
		}
		
		protected function dispose(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME , moveSkinUp );
			removeEventListener(Event.ENTER_FRAME , moveSkinDown );
			/*if(progressTimer){
				progressTimer.stop();
				progressTimer.removeEventListener(TimerEvent.TIMER,updateProgress);
			}
			if(bufferTimer){
				bufferTimer.stop();
				bufferTimer.removeEventListener(TimerEvent.TIMER,updateBuffer);
			}*/
			
//			removeEventListener(Event.REMOVED_FROM_STAGE , dispose);
		}
		
		public function disconnect():void
		{
			removeEventListener(Event.ENTER_FRAME , moveSkinUp );
			removeEventListener(Event.ENTER_FRAME , moveSkinDown );
			if(progressTimer){
				progressTimer.stop();
				progressTimer.removeEventListener(TimerEvent.TIMER,updateProgress);
			}
			if(bufferTimer){
				bufferTimer.stop();
				bufferTimer.removeEventListener(TimerEvent.TIMER,updateBuffer);
			}
			player.disconnect();
			isConnected=false;
		}
		
		private function initVDO():void
		{
			player.addEventListener(PlayerVdoEvent.BUFFER_EMPTY , function():void{
				if(!vdoLoadedAll)loading.show(); 
			} );
			player.addEventListener(PlayerVdoEvent.BUFFER_FULL , function():void{
				loading.hide();
			});
			player.addEventListener( PlayerVdoEvent.CONNECTED , connected );
			loading.hide();
			if(!thumbUrl){
				connect();
			}
		}
		
		private function connect():void
		{
			loading.show();
			player.connect();
			isConnected=true;
		}
		
		private function connected( event:PlayerVdoEvent=null):void
		{
			addChildAt(vdo , getChildIndex(bg)+1 );
			setSize(width,height);
			
			skin.playSkin();
			
			progressTimer.start();
			bufferTimer.start();
		}
		
		/*********************************************************
		//********* HIDE SKIN EVENT ******************************
		//********************************************************/
		
		protected function overSkin(event:MouseEvent):void
		{
			//			trace('overSkin');
			clearTimeout(timeoutHideSkin);
			isOverSkin = true;
		}
		
		protected function outSkin(event:MouseEvent):void
		{
			//			trace('outSkin');
			isOverSkin = false;
			updateShowSkin();
		}
		
		protected function updateShowSkin(event:MouseEvent=null):void
		{
			//			trace('showSkin...');
			clearTimeout(timeoutHideSkin);
			showSkin();
			timeoutHideSkin = setTimeout(hideSkin,4000);
		}
		
		private function showSkin():void
		{
			isHideSkin=false;
			removeEventListener(Event.ENTER_FRAME , moveSkinDown );
			addEventListener(Event.ENTER_FRAME , moveSkinUp );
		}
		
		protected function moveSkinUp(event:Event):void
		{
			//			trace( 'moveSkinUp');
			skin.y += (height - (skin.y + skin.height))/2;
			if(Math.abs(height - (skin.y + skin.height)) < .1 ){
				skin.y = height-skin.height;
				removeEventListener(Event.ENTER_FRAME , moveSkinUp );
			}
		}
		
		protected function hideSkin():void
		{
			//			trace('isOverSkin='+isOverSkin);
			if(!isOverSkin){
				isHideSkin=true;
				removeEventListener(Event.ENTER_FRAME , moveSkinUp );
				addEventListener(Event.ENTER_FRAME , moveSkinDown );
			}
		}
		
		protected function moveSkinDown(event:Event):void
		{
			//			trace( 'moveSkinDown');
			skin.y += (height+2 - skin.y)/5;
			if( Math.abs(height+2 - skin.y) < .3 ){
				skin.y = height+2;
				removeEventListener(Event.ENTER_FRAME , moveSkinDown );
			}
		}
		
		/*********************************************************
		//********* VDO CONTROLL ******************************
		//********************************************************/
		
		protected function bgClick(event:MouseEvent):void
		{
			if( isPeriodDoubleClick ){
				clearTimeout( timeoutDoubleClick );
				isPeriodDoubleClick = false;
				skin.toggleFullscreen();
			}else{
				isPeriodDoubleClick = true;
				timeoutDoubleClick = setTimeout( function():void{isPeriodDoubleClick=false;} , 300 );
			}
			skin.togglePlayPause();
		}	
		protected function updateBuffer(event:TimerEvent):void
		{
			skin.updateBuffer( player.startBytes , player.bytesLoaded );
			if(player.bytesLoaded>=1){
				vdoLoadedAll=true;
				bufferTimer.stop();
			}
		}
		
		protected function volumn(event:PlayerSkinEvent):void
		{
			player.volumn = event.value;
		}
		
		protected function updateProgress(event:TimerEvent):void
		{  
			skin.updateProgress( player.time , player.duration );	
		}
		
		private function play(event:PlayerSkinEvent):void
		{
			if(isConnected){
				isPlay=true;
				player.play();
				progressTimer.start();
			}else{
				connect();
			}
		}
		
		private function pause(event:PlayerSkinEvent):void
		{
			isPlay=false;
			progressTimer.stop();
			player.pause();	
		}
		
		protected function seek(event:PlayerSkinEvent):void
		{
			// first time seek pause vdo 
			if(!isSeeking){
				isSeeking=true;
				if(isPlay)player.pause();
				tempIsPlay = isPlay;
			}
			// last seek play vdo
			if(event.state==1){
				isSeeking=false;
				if(tempIsPlay)player.play();
				skin.updateProgress( player.time , player.duration );
			}
			player.seek(event.value);
		}
		
		protected function toggleFullscreen(event:Event):void
		{
			if(stage){
				signalEvent.dispatch(TOGGLE_FULLSCREEN);
			}
		}
		
		public function setSize( $width:Number , $height:Number ):void
		{
			player.setSize($width,$height);
			if(skin){
				if(isHideSkin){
					skin.y = $height;
				}else{
					skin.y = $height-skin.height;
				}
				skin.width = $width;
			}
			/*if(thumb){
				thumb.setWidthHeight($width,$height);
			}
			if(skin.playPauseSign.visible==true){
				skin.playPauseSign.x = $width/2;
				skin.playPauseSign.y = $height/2;
			}*/
			
			loading.x = $width/2;
			loading.y = $height/2;
			bg.width=$width;
			bg.height=$height;
			_width=$width;
			_height=$height;
		}
		
		//**********************************************************
		//********* GET SET ******************************
		//*******************************************************
		public function get showAll():Boolean
		{
			return player.showAll;
		}
		public function set showAll( $value:Boolean ):void
		{
			player.showAll = $value;
		}
		public override function get width():Number
		{
			return _width;
		}
		public override function set width( $value:Number ):void
		{
			setSize( $value , height );
		}
		public override function get height():Number
		{
			return _height;
		}
		public override function set height( $value:Number ):void
		{
			setSize( width , $value );
		}
		
		
		public override function get scaleX():Number{return 0;}
		public override function get scaleY():Number{return 0;}
		public override function set scaleX( $value:Number ):void{}
		public override function set scaleY( $value:Number ):void{}
	}
}