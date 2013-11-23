package net.area80.component.embed.button
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	/**
	* BrightnessButton
	* @author Wissarut Pimanmassuriya
	*/
	public class BrightnessButton extends MovieClip
	{
		public var rollOverBrightness:Number = 50;
		private var isOver:Boolean = false;
		private var setBrightness:Number = 0;
		private var _brightness:Number = 0;
		
		public function BrightnessButton ():void {
				if (getChildByName("hit")) hitArea = getChildByName("hit") as Sprite;
				buttonMode = true;
				addEventListener(Event.ADDED_TO_STAGE, initUpdate, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, clearUpdate, false, 0, true);
		}
		private function initUpdate (e:Event):void {
			stop();
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, upHandler, false, 0, true);
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		private function clearUpdate (e:Event):void {
			stop();
			removeEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			removeEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			removeEventListener(Event.ENTER_FRAME, update);
		}
		private function update (e:Event):void {
				_brightness += (setBrightness - _brightness) * 0.2;
				var bp:Number = (100 - _brightness) * 0.01;
				var ap:Number = _brightness * 2.55;
				var c:ColorTransform = new ColorTransform(bp, bp, bp, 1, ap, ap, ap);
				this.transform.colorTransform = c;
		}
		private function mouseHandler (e:MouseEvent):void {
				var c:ColorTransform;
				if (e.type == MouseEvent.ROLL_OVER) {
					setBrightness = rollOverBrightness;
					isOver = true;
				} else if (e.type == MouseEvent.ROLL_OUT) {
					setBrightness = 0;
					isOver = false;
				}
		}
		private function downHandler (e:MouseEvent):void {
				if (isOver) {
					setBrightness = rollOverBrightness - 80;
				}
		}
		private function upHandler (e:MouseEvent):void {
				if (isOver) {
					mouseHandler(new MouseEvent(MouseEvent.ROLL_OVER));
				}
		}
	}
	
}