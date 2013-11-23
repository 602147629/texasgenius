package com.iamintaxi.util
{

	import flash.geom.Rectangle;

	import gs.TweenLite;

	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Touch;

	public class SlideToStartComposer
	{
		public static const START:String = "start";
		public static const STOP:String = "stop";
		public var signalStatusChange:Signal = new Signal(String);

		private var btn:DisplayObject;
		private var leftX:Number;
		private var rightX:Number;

		private var startMouseX:Number;
		private var startBtnX:Number;
		private var nowStatus:Number = 0;

		public function SlideToStartComposer(_btn:DisplayObject, _leftX:Number, _rightX:Number)
		{
			btn = _btn;
			leftX = _leftX;
			rightX = _rightX;

			btn.x = leftX;

			var btnTouch:TouchComposer = new TouchComposer(btn);
			btnTouch.mouseDown(mouseDown);
			btnTouch.mouseMove(mouseMove);
			btnTouch.mouseUp(mouseUp);
		}

		private function mouseDown(_touch:Touch):void
		{
			startMouseX = _touch.globalX;
			startBtnX = btn.x;
		}

		private function mouseMove(_touch:Touch):void
		{
			btn.x = startBtnX+(_touch.globalX-startMouseX);
			if (btn.x<leftX) {
				btn.x = leftX;
			} else if (btn.x>rightX) {
				btn.x = rightX;
			}
		}

		private function mouseUp(_touch:Touch):void
		{
			if (nowStatus==0) {
				if (btn.x==rightX) {
					nowStatus = 1;
					signalStatusChange.dispatch(START);
				} else {
					TweenLite.to(btn, .2, {x: leftX});
				}
			} else if (nowStatus==1) {
				if (btn.x==leftX) {
					nowStatus = 0;
					signalStatusChange.dispatch(STOP);
				} else {
					TweenLite.to(btn, .2, {x: rightX});
				}
			}
		}
	}
}
