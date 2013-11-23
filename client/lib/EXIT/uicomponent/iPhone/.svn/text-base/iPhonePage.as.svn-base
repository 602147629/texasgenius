package EXIT.uicomponent.iPhone
{
	
	import EXIT.service.snapPosition;
	
	import com.greensock.BlitMask;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class iPhonePage extends Sprite
	{
		protected static var HORIZONTAL		:	String = 'horizontal';
		protected static var VERTICAL		:	String = 'vertical';
		
		protected var _container 			:	DisplayObjectContainer;
		protected var _scrollSprite			:	Sprite;
		
		protected var magnitude				:	Number;
		protected var direction				:	String;
		protected var positionType			:	String;
		protected var mousePositionType		:	String;
		protected var areaMagnitude			:	String;
		protected var magnitudeContainType	:	String;
		protected var positionPageCentre	:	Number;
		
		protected var useBlitMask			:	Boolean;
		protected var maxScrollRatio		:	Number;
		protected var _scrollOn				:	Boolean = false;
		protected var _canMove				:	Boolean = false;
		
		protected var _interact				:	Boolean = false;
		//---- CONTAIN MOVE ---
		protected var startPostion			: 	Number;
		protected var startMousePosition	:	Number;
		protected var lastMousePostion		:	Number;
		protected var speed					:	Number;
		protected var finalDestination		: 	Number; // use only inertia function
		public static var maxSpeed			:	Number = 100;
		public static var DELAY_SCROLL_FADE	:	Number = .4;
		public static var DELAY_MOVE_BACK	:	Number = .4;
		public static var deacceletion		:	Number = 1;
		
		public var blit						:	BlitMask;
		public var areaWidth 	 			:	Number;
		public var areaHeight 				:	Number;
		public var signalPage				:	Signal;
		
		//---- temp for customer ---
		public var signalDirection			: 	Signal;
		public var downDirection			: 	Number = 1;
		
		
		public static var START				:	String = 'start';
		public static var STOP				:	String = 'stop';
		/**
		 * 
		 * @param $areaWidth 
		 * @param $areaHeight
		 * @param $useBlitMask
		 * @param $direction
		 * 
		 */		
		public function iPhonePage( $areaWidth : Number , $areaHeight : Number , $useBlitMask : Boolean = true , $direction : String = null)
		{
			super();
			areaWidth = $areaWidth;
			areaHeight = $areaHeight;
			useBlitMask = $useBlitMask;
			if($direction) direction = $direction;
			else direction = VERTICAL;
			if( direction == HORIZONTAL ) positionType = 'x';
			else positionType = 'y';
			if( direction == HORIZONTAL ) mousePositionType = 'mouseX';
			else mousePositionType = 'mouseY';
			if( direction == HORIZONTAL ) areaMagnitude = 'areaWidth';
			else areaMagnitude = 'areaHeight';
			magnitude = this[areaMagnitude];
			if( direction == HORIZONTAL ) magnitudeContainType = 'width';
			else magnitudeContainType = 'height';
			
			signalPage = new Signal( String );
			signalDirection = new Signal( Number );
			positionPageCentre = this[areaMagnitude] / 2;
			addEventListener( Event.ADDED_TO_STAGE , initialize );
			
		}

		

		protected function initialize(event:Event):void
		{
//			trace('added');
			removeEventListener( Event.ADDED_TO_STAGE , initialize );
			addEventListener( Event.REMOVED_FROM_STAGE , dispose );
			
			graphics.beginFill( 0x000000 , 0 );
			graphics.drawRect( 0,0,areaWidth,areaHeight);
			graphics.endFill();
//			mouseChildren = false;
		}
		
		protected function md(event:MouseEvent):void
		{
//			event.stopPropagation();
//			trace('iPhonePage::: md');
//			dispatchEvent(new MouseEvent( MouseEvent.MOUSE_UP ) );
			signalPage.dispatch( START );
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE , mm );
			
			startPostion = position;
			startMousePosition = this[mousePositionType];
			lastMousePostion = startMousePosition;
			
			
			removeEventListener( Event.ENTER_FRAME , inertia );
			TweenLite.killTweensOf( this );
			addEventListener( Event.ENTER_FRAME , moveContain );
			moveContain();
			stage.addEventListener( MouseEvent.MOUSE_UP , mu );

			addEventListener( Event.ENTER_FRAME , checkScroll );
		}
		
		protected function mm(event:MouseEvent):void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_container.x = Math.round(_container.x);
			_container.y = Math.round(_container.y);
			stage.removeEventListener( MouseEvent.MOUSE_MOVE , mm );
		}
		
		protected function mu(event:MouseEvent):void
		{
			removeEventListener( Event.ENTER_FRAME , moveContain );
			stage.removeEventListener( MouseEvent.MOUSE_UP , mu );
			
			if( position < this[areaMagnitude] - magnitude ){					
				goBack( this[areaMagnitude] - magnitude );
			}else if( position > 0 ){
				goBack( 0 );
			}else{
				addEventListener( Event.ENTER_FRAME , inertia );
			}
			stage.removeEventListener( MouseEvent.MOUSE_MOVE , mm );
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		
		protected function checkScroll(event:Event):void
		{
//			trace(' scroll ');
			scrollSprite[positionType] = - container[positionType] / maxScrollRatio;
		}
		
		protected function inertia(event:Event):void
		{
//			trace(' inertia , interactive'+interact);
			speed = (speed)?( speed/Math.abs(speed) ) * ( Math.abs(speed)-deacceletion ):0;
			position += speed;
			if( Math.abs(speed) <= deacceletion ){
				removeEventListener( Event.ENTER_FRAME , inertia );
				removeEventListener( Event.ENTER_FRAME , checkScroll );
				if(scrollOn) scrollOn=false;
			}
			if( position < this[areaMagnitude] - magnitude ){
				speed *= .5;
				if(speed < -maxSpeed) speed = -maxSpeed;
				finalDestination = ( (speed / maxSpeed) * (this[areaMagnitude]/2 ) - ( magnitude - this[areaMagnitude] ) );
				if( position <= finalDestination ){
					removeEventListener( Event.ENTER_FRAME , inertia );
					goBack( this[areaMagnitude] - magnitude );
				}
			}else if( position > 0 ){
				speed *= .5;
				if(speed > maxSpeed) speed = maxSpeed;
				finalDestination = ( (speed / maxSpeed) * this[areaMagnitude]/2 );
				if( position >= finalDestination ){
					removeEventListener( Event.ENTER_FRAME , inertia );
					goBack( 0 );
				}
			}
			checkInvertArrow();
		}
		protected function goBack( $value : Number):void{
//			trace('goback');
			TweenLite.to( this , DELAY_MOVE_BACK , { position : $value , ease : Sine.easeOut , onComplete : function():void{
				removeEventListener( Event.ENTER_FRAME , checkScroll );
				if(scrollOn) scrollOn=false;
			}
			});
			
		}
		protected function checkInvertArrow():void
		{
			if(position > 0){
				if(downDirection < 0 ){
					downDirection = 1;
					signalDirection.dispatch(1);
//					trace(downDirection);
				}
			}else if( position < this[areaMagnitude] - magnitude ){
				if(downDirection > 0 ){
					downDirection = -1;
					signalDirection.dispatch(-1);
//					trace(downDirection);					
				}
			}
		}
		protected function moveContain(event:Event=null):void
		{
//			trace(' movecontain ');
			if( mouseX < 0 || mouseY < 0 || mouseX > areaWidth || mouseY >areaHeight ){
				stage.dispatchEvent(new MouseEvent( MouseEvent.MOUSE_UP ));
			}else{
				if( !scrollOn ){
					if(	startMousePosition != this[mousePositionType] ){
						scrollOn = true;
					}
				}
				
				speed = this[mousePositionType] - lastMousePostion;
				if(position > 0 || position < this[areaMagnitude] - magnitude){
					position += speed/2;
				}else{
					position += speed;
				}
				position = Math.round(position);
				lastMousePostion = this[mousePositionType];
			}
			checkInvertArrow();
//			trace(position+' : '+this[mousePositionType]+' : '+mousePositionType+' : '+mouseY);
		}
		protected function moved():void{
			signalPage.dispatch( STOP );
		}
		
		//------------------------------------------------
		//---------------SET FUNCTION---------------------
		//------------------------------------------------
		
		public function set scrollOn( $value : Boolean ) : void
		{
			if( $value ){
				if(blit) blit.enableBitmapMode();
				TweenLite.to( scrollSprite , DELAY_SCROLL_FADE ,{ alpha : 1 } );
			}else{
				if(blit)blit.disableBitmapMode();
				
				TweenLite.to( scrollSprite , DELAY_SCROLL_FADE ,{ alpha : 0 , onComplete : moved} );
			}
			
			_scrollOn = $value;
		}
		public function set position( $value : Number ):void
		{
			_container[positionType] = $value;
		}
		public function set container( $object : DisplayObjectContainer ):void
		{
			/////////// REMOVED OLD /////////////
			/*if(blit) blit.dispose();
			if(stage){
				stage.removeEventListener( MouseEvent.MOUSE_UP , mu );
				stage.removeEventListener( MouseEvent.MOUSE_MOVE , mm );
			}
			removeEventListener( Event.ENTER_FRAME , inertia );
			removeEventListener( Event.ENTER_FRAME , moveContain );
			removeEventListener( Event.ENTER_FRAME , checkScroll );
			
			if(_scrollSprite)removeChild(_scrollSprite);
			_scrollSprite = null;
			moved();*/
			/////////////////////////////////////////////
			if( _container ){
				removeChild(_container);
			}
			_container = $object;
			if(_container[magnitudeContainType] > this[areaMagnitude]){ 
				magnitude = _container[magnitudeContainType];
				_canMove = true;
			}else{
				magnitude = this[areaMagnitude];
				scrollSprite.visible = false;
				_canMove = false;
			}
			
			
			addChild( _container );
			if(useBlitMask) {
				snapPosition.snapAll( _container );
//				trace('____________ bt convert ');
				blit = new BlitMask( _container , _container.x , _container.y , areaWidth , areaHeight , false , true );
				blit.bitmapMode = false;
				blit.mouseEnabled = false;
			}
			maxScrollRatio = ( _container[magnitudeContainType] - this[areaMagnitude] ) / ( this[areaMagnitude] - scrollSprite[magnitudeContainType] );
			addEventListener( MouseEvent.MOUSE_DOWN , md );
		}
		
		public function set scrollSprite( $object : Sprite ):void
		{
			if( _scrollSprite ){
				if(_scrollSprite.parent) _scrollSprite.parent.removeChild(_scrollSprite);
			}
			_scrollSprite = $object;
			_scrollSprite.x = areaWidth - _scrollSprite.width - 3;
			_scrollSprite.alpha = 0;
		}
		public function set interact( $value : Boolean ):void
		{
			/*if( $value ) addEventListener(MouseEvent.MOUSE_DOWN , md );
			else removeEventListener(MouseEvent.MOUSE_DOWN , md );*/
			this.mouseChildren = $value;
			this.mouseEnabled = $value;
			_interact = $value;
		}
		
		//------------------------------------------------
		//---------------GET FUNCTION---------------------
		//------------------------------------------------
		public function get interact():Boolean
		{
			return _interact;
		}
		public function get scrollOn():Boolean
		{
			return _scrollOn;
		}
		public function get position() : Number
		{
			return _container[positionType];
		}
		public function get container() : DisplayObjectContainer
		{
			return _container;
		}
		public function get scrollSprite() : Sprite
		{
			if( !_scrollSprite ){
				_scrollSprite = new Sprite();
				_scrollSprite.graphics.beginFill( 0xaaaaaa );
				var a :Number;
				var b :Number;
				if(direction == HORIZONTAL){
					a = areaWidth * areaWidth / magnitude;
					b = 5;
				}else{
					a = 5;
					b = areaHeight * areaHeight / magnitude;
				} 
				
				_scrollSprite.graphics.drawRoundRect( 0 , 0 , a , b , 5 , 5);
				scrollSprite = _scrollSprite;
				addChild(_scrollSprite);
//				trace('.... scrb ::: ');
			}
			return _scrollSprite;
		}
		public function get canMove():Boolean
		{
			return _canMove;
		}
		
		
		
		protected function dispose(event:Event):void
		{
			if(blit) blit.dispose();
			stage.removeEventListener( MouseEvent.MOUSE_UP , mu );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE , mm );
			removeEventListener( Event.ENTER_FRAME , inertia );
			removeEventListener( Event.ENTER_FRAME , moveContain );
			removeEventListener( Event.ENTER_FRAME , checkScroll );
			removeEventListener( Event.REMOVED_FROM_STAGE , dispose );
		}
	}
}