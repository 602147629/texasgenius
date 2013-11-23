package EXIT.uicomponent.iPhone
{
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	public class PagesMove extends Sprite
	{
		public static const VERTICAL 			: 	String = 'vertical';
		public static const HORIZONTAL 			: 	String = 'horizontal';
		
		protected static const NOW_PAGE			: 	String = 'nowPage';
		protected static const NEXT_PAGE		: 	String = 'nextPage';
		protected static const PREV_PAGE		: 	String = 'prevPage';
		
		public static const START				:	String = 'start';
		public static const STOP				:	String = 'stop';
		
		public var signalPage					:	Signal;
		public var signalNowPage				:	Signal;
		public var areaWidth					:	Number;
		public var areaHeight					: 	Number;
		
		protected var _nowPage 					: 	int = 0;
		
		public static var DELAY					: 	Number = .5;
		public static var speedLimit 			: 	Number = 15;
		//------------ POSITION ---------------//
		protected var _position					:	Number;
		protected var positionType 				: 	String;
		protected var mousePositionType			: 	String;
		protected var magnitude 				:	Number;
		
		protected var startIndexShowing			: 	int;
		protected var endIndexShowing			: 	int;
		
		//- new Structure --
		protected var vectorPages				:	Vector.<DisplayObject>;
		protected var dictMyPage				:	Dictionary = new Dictionary();
		//use only in position function
		protected var fractionPage				: 	Number;
		protected var positionPageCentre		: 	Number;
		
		//------ drag -
		private var startPostion 				: 	Number;
		private var startMousePostion 			: 	Number;
		private var lastMousePostion			: 	Number;
		private var speed						: 	Number;
		
		protected var i							: 	uint;
		protected var _interact 				:	Boolean = false;
		public function PagesMove( $width : Number , $height : Number , $vectorPages:Vector.<DisplayObject> , $direction : String = HORIZONTAL )
		{
			super();
			
			magnitude = ($direction == HORIZONTAL) ? $width : $height;
			areaWidth = $width;
			areaHeight = $height;
			vectorPages = $vectorPages;
			positionType = ($direction == HORIZONTAL) ? 'x' : 'y';
			mousePositionType = ($direction == HORIZONTAL) ? 'mouseX' : 'mouseY';
			positionPageCentre = magnitude / 2;
			
			signalPage = new Signal(String);
			signalNowPage = new Signal(uint);
			
			addEventListener( Event.ADDED_TO_STAGE , initialize );
			addEventListener(MouseEvent.MOUSE_DOWN , dragMe );
		}
		
		protected function initialize(event:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , initialize );
			addEventListener( Event.REMOVED_FROM_STAGE , dispose );
			
			graphics.beginFill(0x000000 , 0 );
			graphics.drawRect(0,0,areaWidth,areaHeight);
			graphics.endFill();
			for(i=0;i<=vectorPages.length-1;i++){
				addChild( vectorPages[ i ]);
			}
			position = 0;
			signalNowPage.dispatch(0);
		}
		
		protected function dragMe(event:MouseEvent):void
		{
//			trace('pageMove::: drag ');
			TweenLite.killTweensOf(this);
				
			startMousePostion = this[mousePositionType];
			startPostion = position;
			lastMousePostion = startMousePostion;
			speed = 0;
			signalPage.dispatch( START );
			stage.addEventListener( MouseEvent.MOUSE_UP , dropMe );
			addEventListener( Event.ENTER_FRAME , checkPosition );
			stage.addEventListener(MouseEvent.MOUSE_MOVE , mm );
		}
		
		protected function mm(event:MouseEvent):void
		{
			mouseEnabled = false;
			mouseChildren = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE , mm );
		}
		
		protected function dropMe(event:MouseEvent):void
		{
//			trace('drop me ');
			stage.removeEventListener(MouseEvent.MOUSE_MOVE , mm );
			mouseEnabled = true;
			mouseChildren = true;
			stage.removeEventListener( MouseEvent.MOUSE_UP , dropMe );
			removeEventListener( Event.ENTER_FRAME , checkPosition );
			
			if( speed > speedLimit  ){
				if( nowPage-1 < 0 ){
//					trace(' not prev ');
					animate()
				}else{
//					trace(' prev ');
					prevPage();
				}
			}else if( speed < -speedLimit ){
				if( nowPage+1 > vectorPages.length - 1 ){
//					trace(' not next ');
					animate()
				}else{
//					trace(' next ');
					nextPage();
				}
			}else{
//				trace( ' stay ');
				nowPage = -Math.round(position / magnitude);
//				trace('dropMe:::'+nowPage);
				if( nowPage < 0 ) _nowPage = 0;
				if( nowPage > vectorPages.length-1 ) nowPage = vectorPages.length-1;
				animate();
			}
		}
		
		protected function animate():void
		{
			TweenLite.to( this ,  DELAY ,{ position : - nowPage * magnitude /*, ease:Expo.easeOut*/ , onComplete : function():void{
					signalPage.dispatch( STOP );
				} 
			});
		}
		protected function checkPosition(event:Event):void
		{
			if( mouseX < 0 || mouseY < 0 || mouseX > areaWidth || mouseY >areaHeight ){
				stage.dispatchEvent(new MouseEvent( MouseEvent.MOUSE_UP ));
			}else{
				speed = this[mousePositionType] - lastMousePostion;
				if( position > 0 || position < -(vectorPages.length-1) * magnitude ){
	//				trace(' position>0 , position='+position);
					position += speed/2;
				}else{
	//				trace(' else , position='+position);
					position += (speed);
				}
				lastMousePostion = this[mousePositionType];
			}
		}
		
		
		
		
		
		
		
		
		public function set position( $value : Number ):void
		{
			var tempPage : Number = $value / magnitude;
			var lessShowPage : int = -Math.floor( tempPage );
			var moreShowPage : int = -Math.ceil( tempPage );
//			trace( ' lessShowPage:'+lessShowPage+'   moreShowPage:'+moreShowPage );
			
			var isLess : Boolean = true;
			for(i=0 ; i<=vectorPages.length-1;i++){
				if( i == lessShowPage ||  i == moreShowPage ){
					vectorPages[i][positionType] = magnitude*i + $value;
					isLess = false;
				}else{
					if( isLess ){
						if( vectorPages[i][positionType] != -magnitude )vectorPages[i][positionType] = -magnitude;
					}else{
						if( vectorPages[i][positionType] != magnitude ) vectorPages[i][positionType] = magnitude;
					}
				}
			}
			_position = $value;
		}
		
		
		public function nextPage():void
		{
			if( nowPage + 1 <= vectorPages.length - 1 ){
				nowPage++;
				animate();
			}
		}
		public function prevPage():void
		{
			if( nowPage - 1 >= 0 ){
				nowPage--;
				animate();
			}
		}
		
		/*protected function newPage( $id : uint ):DisplayObjectContainer
		{
			var sp : Sprite = new Sprite();
			sp.graphics.beginFill( 0xaaaaaa );
			sp.graphics.drawRoundRect( 0 , 0 ,magnitude-10 , magnitude ,10,10 );
			sp.graphics.endFill();
			
			return sp;
		}*/
		public function set interact( $value : Boolean ):void
		{
			if( $value ) addEventListener(MouseEvent.MOUSE_DOWN , dragMe );
			else removeEventListener(MouseEvent.MOUSE_DOWN , dragMe );
//			trace(' interact : '+$value);
			_interact = $value;
		}
		public function set nowPage( $value :uint):void
		{
			signalNowPage.dispatch($value);
			_nowPage = $value;
//			trace('nowPage::'+$value);
		}
		
		public function get interact():Boolean
		{
			return _interact;
		}
		public function get position():Number
		{
			return _position;
		}
		public function get nowPage():uint
		{
			return _nowPage;
		}
		
		
		protected function dispose(event:Event):void
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP , dropMe );
			stage.removeEventListener(MouseEvent.MOUSE_MOVE , mm );
		}
	}
}