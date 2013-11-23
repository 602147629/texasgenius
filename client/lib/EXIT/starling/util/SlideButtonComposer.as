package com.iamintaxi.util
{

	import gs.TweenLite;

	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Touch;

	public class SlideButtonComposer
	{
		public static const ON:String = "on";
		public static const OFF:String = "off";
		public var signalStatusChange:Signal = new Signal(String);

		private var MOVE_DIV:Number = 4;

		private var btn:DisplayObject;
		private var background:DisplayObject;
		private var leftX:Number;
		private var rightX:Number;

		private var startMouseX:Number;
		private var startBtnX:Number;
		private var nowStatus:Number = 0;
		private var isMove:Boolean = false;

		private var centerX:Number;

		public function SlideButtonComposer(_btn:DisplayObject, _background:DisplayObject, _leftX:Number, _rightX:Number)
		{
			btn = _btn;
			background = _background;
			leftX = _leftX;
			rightX = _rightX;
			btn.x = leftX;
			centerX = (leftX+rightX)*.5;

			var btnTouch:TouchComposer = new TouchComposer(btn);
			btnTouch.mouseDown(mouseDown);
			btnTouch.mouseMove(mouseMove);
			btnTouch.mouseUp(mouseUp);

			var bgTouch:TouchComposer = new TouchComposer(background);
			bgTouch.mouseDown(mouseDown);
			bgTouch.mouseMove(mouseMove);
			bgTouch.mouseUp(mouseUp);
		}

		private function mouseDown(_touch:Touch):void
		{
			startMouseX = _touch.globalX;
			startBtnX = btn.x;
			isMove = false;
		}

		private function mouseMove(_touch:Touch):void
		{
			if (_touch.target==btn) {
				btn.x = startBtnX+(_touch.globalX-startMouseX);
				if (btn.x<leftX) {
					btn.x = leftX;
				} else if (btn.x>rightX) {
					btn.x = rightX;
				}
			}
			if (Math.abs(btn.x-startBtnX)>MOVE_DIV) {
				isMove = true;
			}
		}

		private function mouseUp(_touch:Touch):void
		{
			if (!isMove) {
				clickToggle();
				return;
			}
			if (nowStatus==0) {
				if (btn.x>centerX) {
					nowStatus = 1;
					TweenLite.to(btn, .1, {x: rightX});
					signalStatusChange.dispatch(ON);
				} else {
					TweenLite.to(btn, .1, {x: leftX});
				}
			} else if (nowStatus==1) {
				if (btn.x<centerX) {
					nowStatus = 0;
					TweenLite.to(btn, .1, {x: leftX});
					signalStatusChange.dispatch(OFF);
				} else {
					TweenLite.to(btn, .1, {x: rightX});
				}
			}
		}

		private function clickToggle(_touch:Touch = null):void
		{
			if (nowStatus==0) {
				nowStatus = 1;
				TweenLite.to(btn, .1, {x: rightX});
				signalStatusChange.dispatch(ON);
			} else {
				nowStatus = 0;
				TweenLite.to(btn, .1, {x: leftX});
				signalStatusChange.dispatch(OFF);
			}
		}
	}
}
