package EXIT.starling.util
{

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TouchComposer
	{
		public var obj:DisplayObject;

		private var mIsDown:Boolean = false;
		private var MAX_DRAG_DIST:Number = 10;
		private var mouseDownCallBack:Function;
		private var mouseUpCallBack:Function;
		private var mouseMoveCallBack:Function;
		private var clickCallBack:Function;
		private var clickAlpha:Boolean;

		//// move check
		private var startMouseDownPoint:Point;
		private const MOVE_DISTANCE:Number = 8;
		private var isMoved:Boolean = false;
		private var isScroll:Boolean = false;


		public function TouchComposer(_obj:DisplayObject, _clickAlpha:Boolean = false, _mouseDownFunction:Function = null, _mouseUpFunction:Function = null, _clickFunction:Function = null)
		{
			obj = _obj;
			if (_mouseDownFunction!=null) {
				mouseDownCallBack = _mouseDownFunction;
			}
			if (_mouseUpFunction!=null) {
				mouseUpCallBack = _mouseUpFunction;
			}
			if (_clickFunction!=null) {
				clickCallBack = _clickFunction;
			}
			clickAlpha = _clickAlpha;
			obj.addEventListener(TouchEvent.TOUCH, mouseEvent);
		}

		public function set isScrollPage(_value:Boolean):void
		{
			isScroll = _value;
		}

		public function get isScrollPage():Boolean
		{
			return isScroll;
		}

		public function mouseDown(callback:Function):void
		{
			mouseDownCallBack = callback;
		}

		public function removeMouseDown():void
		{
			mouseDownCallBack = null;
		}

		public function mouseUp(callback:Function):void
		{
			mouseUpCallBack = callback;
		}

		public function removeMouseUp():void
		{
			mouseUpCallBack = null;
		}

		public function mouseMove(callback:Function):void
		{
			mouseMoveCallBack = callback;
		}

		public function removeMouseMove():void
		{
			mouseMoveCallBack = null;
		}

		public function click(callback:Function):void
		{
			clickCallBack = callback;
		}

		public function removeClick():void
		{
			clickCallBack = null;
		}

		public function start():void
		{

			obj.addEventListener(TouchEvent.TOUCH, mouseEvent);
		}

		public function stop():void
		{
			obj.removeEventListener(TouchEvent.TOUCH, mouseEvent);
		}

		public function mouseEvent(e:TouchEvent):void
		{
			var btn:DisplayObject = DisplayObject(e.currentTarget);
			var touch:Touch = e.getTouch(btn);
			if (touch==null)
				return;

			if (touch.phase==TouchPhase.BEGAN&&!mIsDown) {
				isMoved = false;
				if (clickAlpha)
					btn.alpha = .5;
				if (mouseDownCallBack!=null)
					mouseDownCallBack(touch);
				startMouseDownPoint = new Point(touch.globalX, touch.globalY);


//				var t:Touch = e.getTouch(btn.parent);
//				var nt:Touch = new Touch( t.id , t.globalX , t.globalY , TouchPhase.ENDED , btn );
//				var touchEvent:TouchEvent = new TouchEvent(TouchEvent.TOUCH ,  new <Touch>[nt] );
//				setTimeout(  function():void{btn.dispatchEvent(  touchEvent ); } , 100 );
				mIsDown = true;
			} else if (touch.phase==TouchPhase.MOVED&&mIsDown) {
				if (mouseMoveCallBack!=null)
					mouseMoveCallBack(touch);

				if (isScroll) {
					if (Math.abs(touch.globalY-startMouseDownPoint.y)>MOVE_DISTANCE&&!isMoved) {
						if (clickAlpha)
							btn.alpha = 1;
						if (mouseUpCallBack!=null)
							mouseUpCallBack(touch);
						isMoved = true;
					}
				}
			} else if (touch.phase==TouchPhase.ENDED) {
				if (clickAlpha)
					btn.alpha = 1;
				if (mouseUpCallBack!=null) {
					mouseUpCallBack(touch);
				}
				var buttonRect:Rectangle = btn.getBounds(btn.stage);
				if ((touch.globalX>buttonRect.x-MAX_DRAG_DIST&&touch.globalY>buttonRect.y-MAX_DRAG_DIST&&touch.globalX<buttonRect.x+buttonRect.width+MAX_DRAG_DIST&&touch.globalY<buttonRect.y+buttonRect.height+MAX_DRAG_DIST)&&mIsDown) {
					if (clickCallBack is Function) {
						if (!isScroll||!isMoved) {
							if (clickCallBack.length>0) {
								clickCallBack(touch);
							} else {
								clickCallBack();
							}
						}
					}
				}
				mIsDown = false;
			}
		}
	}
}
