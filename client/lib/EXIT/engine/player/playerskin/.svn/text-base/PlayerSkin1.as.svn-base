package EXIT.engine.player.playerskin 
{
	
	
	import EXIT.engine.player.playervdo.PlayerVdoEvent;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	[Embed(source='embed/player/playerSkin.swf',symbol='control')]
	public class PlayerSkin1 extends PlayerSkin
	{
//		public var playPauseSign		:MovieClip;
		public var playPauseBtn			:MovieClip;
		public var layerRight			:Sprite;
		public var scrub				:MovieClip;
		public var bgBar				:Sprite;
		public var bufferBar			:Sprite;
		public var progressBar			:Sprite;
		public var referBar				:Sprite;
		public var bg					:Sprite;
		public var timeText				:TextField;
		
		//---- var------ 
		private var dragTimer			:Timer;
		
		//-- property--
		private var bgBarGap			:Number;
		private var isPlay 				:Boolean=false;
		private var _width				:Number=0;
		private var isDrag				:Boolean=false;
		private var totalTime			:String;
		private var defaultYVol			:Number;
		private var volCache        	:Number=1;
		private var isMute        		:Boolean;
		private var isSettingVol		:Boolean=false;
		private var isOverMute			:Boolean=false;
		private var isEndVdo			:Boolean=false;
		private var bgBarWider			:Number = 4;
		private var lastFramePosition 	:Number = 0; // this var is for checking , is the progress equal to totaltime ?. 
										//cause the end of vdo, the progress is a little bit less than total time
										// EX. $time/$duration : 76.485 / 76.5    or   376.542 / 376.563015873
										// so let's it play 1 frame when the approximate value of progress is end.
		
		public function PlayerSkin1()
		{
			bgBarGap = bg.width-bgBar.width;
			referBar.y = progressBar.y = bufferBar.y = bgBar.y;
			referBar.x = bgBar.x+bgBarWider/2;
			referBar.visible =false;
			bufferBar.x = referBar.x;
			progressBar.x = referBar.x;
			progressBar.mouseEnabled=false;
			progressBar.mouseChildren=false;
			
			playPauseBtn.stop();
			playPauseBtn.buttonMode=true;
			playPauseBtn.addEventListener(MouseEvent.CLICK,togglePlayPause);
			scrub.stop();
			scrub.y = bgBar.y;
			scrub.buttonMode=true;
			scrub.addEventListener( MouseEvent.MOUSE_DOWN , dragMe);
			bufferBar.buttonMode=true;
			bufferBar.addEventListener( MouseEvent.MOUSE_DOWN , dragMe);
			
			layerRight['fullscreenBtn'].buttonMode = true;
			layerRight['fullscreenBtn'].stop();
			layerRight['fullscreenBtn'].addEventListener(MouseEvent.CLICK,toggleFullscreen);
			layerRight['muteBtn'].buttonMode = true;
			layerRight['muteBtn'].stop();
			MovieClip( layerRight['muteBtn'] ).addEventListener(MouseEvent.ROLL_OVER,muteOver);
			MovieClip( layerRight['muteBtn'] ).addEventListener(MouseEvent.ROLL_OUT,muteOut);
			MovieClip( layerRight['muteBtn'] ).addEventListener(MouseEvent.CLICK,toggleMute);
			MovieClip( layerRight['muteBtn'] ).mouseChildren=false;
			MovieClip( layerRight['muteBtn'] ).stop();
			
			defaultYVol = layerRight['volumn'].y;
			layerRight['volumn'].y=0;
			Sprite( layerRight['volumn'] ).addEventListener(MouseEvent.ROLL_OVER,muteOver);
			Sprite( layerRight['volumn'] ).addEventListener(MouseEvent.ROLL_OUT,muteOut);
			Sprite( layerRight['volumn']['bg'] ).addEventListener( MouseEvent.MOUSE_DOWN , dragSound ); 
			Sprite( layerRight['volumn']['bg'] ).buttonMode=true;
			
			layerRight['volumn']['scrub'].y = layerRight['volumn']['progress'].y - layerRight['volumn']['progress'].height;
//				Sprite( layerRight['volumn']['scrub'] ).
			timeText.text = formatTime(0);
			
			dragTimer=new Timer(100);
			dragTimer.addEventListener(TimerEvent.TIMER,dragging);
			hideLoading();
			//--- set first for sure ---
			updateBuffer(0,0);
			updateProgress(0,100000);
			//--------------------------
			addEventListener(Event.ADDED_TO_STAGE , initialize );
			addEventListener(Event.REMOVED_FROM_STAGE , dispose);
		}
		
		protected function initialize(event:Event):void
		{
			stage.addEventListener(Event.FULLSCREEN,checkFullscreen);
		}
		
		protected function dispose(event:Event):void
		{
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN,checkFullscreen);
		}
		
		protected function checkFullscreen(event:FullScreenEvent):void
		{
			if (stage.displayState == StageDisplayState.FULL_SCREEN){
				layerRight['fullscreenBtn'].gotoAndStop(3);
			}else{
				layerRight['fullscreenBtn'].gotoAndStop(1);
			}
			dispatchEvent(new PlayerSkinEvent( PlayerSkinEvent.TOGGLE_FULLSCREEN ) );
		}
		
		protected function muteOut(event:MouseEvent):void
		{
//			trace('isSettingVol:'+isSettingVol);
			if(!isSettingVol)
			TweenLite.to(layerRight['volumn'], .2 ,{y:0});
			isOverMute=false;
		}
		
		protected function muteOver(event:MouseEvent):void
		{
			TweenLite.to(layerRight['volumn'], .2 ,{y:defaultYVol});
			isOverMute=true;
		}
		
		
		
		
		protected function alignProgress( $progress:Number ):void
		{
			progressBar.x = referBar.x +  startBuffer*referBar.width;
			progressBar.width = ($progress-startBuffer)*referBar.width;
			if(progressBar.scaleX < 0) progressBar.scaleX = 0;
			scrub.x = progressBar.x + progressBar.width;
		}
		protected function toggleMute(event:MouseEvent):void
		{
			if(isMute){
				layerRight['volumn']['progress'].scaleY = volCache;
			}else{
				layerRight['volumn']['progress'].scaleY = 0;
			}
			layerRight['volumn']['scrub'].y = layerRight['volumn']['progress'].y - layerRight['volumn']['progress'].height;
			setSound();
		}
		/* *******************************
		 * DRAG
		 ********************************/
		//--------------
		// sound bar 
		//--------------
		protected function dragSound(event:MouseEvent):void
		{
			isSettingVol = true;
			addEventListener(Event.ENTER_FRAME , draggingSound);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopDragSound);
			setSound();
		}
		
		protected function draggingSound(event:Event):void
		{
			volCache = layerRight['volumn']['progress'].scaleY;
			var tempY:Number;
			if(	layerRight['volumn']['bg'].mouseY > 0 ) {
				tempY=0;
			}else if( layerRight['volumn']['bg'].mouseY < -layerRight['volumn']['bg'].height ){ 
				tempY = layerRight['volumn']['bg'].height;
			}else{ 
				tempY = -layerRight['volumn']['bg'].mouseY;
			}
			layerRight['volumn']['progress'].height = tempY;
			layerRight['volumn']['scrub'].y = layerRight['volumn']['progress'].y - layerRight['volumn']['progress'].height;
			setSound();
		}
		
		protected function stopDragSound(event:MouseEvent=null):void
		{
			isSettingVol=false;
			if(!isOverMute) MovieClip( layerRight['muteBtn'] ).dispatchEvent( new MouseEvent( MouseEvent.ROLL_OUT) );
			removeEventListener(Event.ENTER_FRAME , draggingSound);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragSound);
			setSound();
		}
		
		private function setSound():void
		{
			var vol:Number = layerRight['volumn']['progress'].scaleY;
			if(vol>0){
				if( isMute ){
					if( volCache != 0){
						layerRight['muteBtn'].gotoAndStop(1);
						isMute = false;
					}
				}
			}else{
				if( !isMute ){
					layerRight['muteBtn'].gotoAndStop(2);
					isMute = true;
				}
			}
			var event:PlayerSkinEvent = new PlayerSkinEvent(PlayerSkinEvent.VOLUMN);
			event.value = vol;
			dispatchEvent(event);
		}		
		//---------------
		// VDO BAR
		//---------------
		protected function dragMe(event:MouseEvent):void
		{
//			addEventListener(Event.ENTER_FRAME , dragging);
//			dragTimer.start();
			dragging();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,dragging);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopDragMe);
			isDrag = true;
		}		
		
		protected function dragging(event:Event=null):void
		{
			var tempX:Number;
			if(mouseX<bufferBar.x) {
				tempX=bufferBar.x;
			}else if(mouseX >= bufferBar.x + bufferBar.width ){
				tempX = bufferBar.x+bufferBar.width;
			}else{ 
				tempX=mouseX;
			}
			scrub.x = tempX;
			seekVdo();
		}
		
		protected function stopDragMe(event:MouseEvent=null):void
		{
			isDrag = false;
//			removeEventListener(Event.ENTER_FRAME , dragging);
//			dragTimer.stop();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragging);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragMe);
			seekVdo(1);
		}
		protected function seekVdo( $isStopDrag:Number=0):void
		{
			progressBar.x = referBar.x +  startBuffer*referBar.width;
			progressBar.width = scrub.x-progressBar.x;
			var event:PlayerSkinEvent = new PlayerSkinEvent( PlayerSkinEvent.SEEK );
			event.value =  (scrub.x-referBar.x) / referBar.width ;
			event.state = $isStopDrag;
//			trace('seek :'+event.value);
			dispatchEvent(event);
			if(isEndVdo){
				isEndVdo=false;
				playSkin();
			}
		}
		/* ********************************
		 * OVERRIDE PlayerSkin
		 *********************************/		
		public override function playSkin():void
		{
			playPauseBtn.gotoAndStop(3);
			isPlay =true;
			scrub.play();
			dispatchEvent(new PlayerSkinEvent(PlayerSkinEvent.PLAY));
		}
		public override function pauseSkin():void
		{
			playPauseBtn.gotoAndStop(1);
			isPlay =false;
			scrub.stop();
			dispatchEvent(new PlayerSkinEvent(PlayerSkinEvent.PAUSE));
		}
		public override function togglePlayPause(event:MouseEvent=null):void
		{
			if(isPlay ){
				pauseSkin();
			}else{
				if(isEndVdo){
					isEndVdo=false;
					var eventSkin:PlayerSkinEvent = new PlayerSkinEvent( PlayerSkinEvent.SEEK );
					eventSkin.value = 0;
					dispatchEvent( eventSkin );
				}
				playSkin();
			}
		}
		
		public override  function toggleFullscreen(event:MouseEvent=null):void
		{
			if (stage.displayState == StageDisplayState.FULL_SCREEN){
				stage.displayState = StageDisplayState.NORMAL;
			}else{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		public override function updateBuffer( $start:Number , $value:Number ):void
		{
//			trace('Buffer :::: $start='+$start+' , $value='+$value);
			if(!$start){$start=0}
			if(!$value) $value=0;
			else if($value<0 || !$value )$value=0;
			else if($value > 1) $value=1;
			
			if($start==1 && $value==0){
				$start=0;
			}
			bufferBar.width = $value*referBar.width;
			bufferBar.x = referBar.x +  $start*referBar.width;
			startBuffer=$start;
			buffer=$value;
//			trace('buffer: '+buffer);
		}
		public override function updateProgress( $time:Number , $duration:Number ):void
		{
			if($duration <= 0 || $duration == Infinity || isNaN($duration) ) $duration=100000;
			progress=$time/$duration;
//			if(!totalTime)totalTime=formatTime($duration);
			timeText.text = formatTime($time);
			if(!isDrag)alignProgress(progress);
			if($time >= ($duration-.1) && $time > .1 ){
				if( $time == lastFramePosition ){
					isEndVdo = true;
					pauseSkin();
				}
				lastFramePosition=$time;
			}else{
				lastFramePosition=0;
			}
			
		}
		
		/* ********************************
		* OVERRIDE DisplayObject
		*********************************/	
		public override function get width():Number
		{
			return _width;
		}
		public override function set width( $value:Number ):void
		{
			if( stage ){
				if (stage.displayState == StageDisplayState.NORMAL){
					$value = $value-20;
					x = 10;
				}else{
					x = 0;
				}
			}
			layerRight.x=$value-1;
			bg.width=$value;
			bgBar.width = $value-bgBarGap;
			referBar.width = bgBar.width-bgBarWider;
			updateBuffer( startBuffer,buffer );
			alignProgress( progress );
			_width=$value;
		}
		public override function get height():Number
		{
			var value:Number;
			
			if (stage && stage.displayState == StageDisplayState.NORMAL){
				value=bg.height+10;
			}else{
				value=bg.height;
			}
			return value;
		}
		/* ***************************
		* SERVICE
		****************************/		
		protected function formatTime(time:Number):String {
			if (time>0) {
				var integer:String = String((time/60)>>0);
				var decimal:String = String((time%60)>>0);
				return ((integer.length<2)?"0"+integer:integer)+":"+((decimal.length<2)?"0"+decimal:decimal);
			} else {
				return String("00:00");
			}
			
		}
		
	}
}