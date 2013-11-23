package net.area80.component.embed.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	/**
	* GoBackButton
	* @author Wissarut Pimanmassuriya
	*/
	public class GoBackButton extends MovieClip
	{
		private var isOver:Boolean = false;
		protected var target:MovieClip;
		
		public function GoBackButton ():void {
				if(!target) target = this;
				if (target.getChildByName("hit")) hitArea = target.getChildByName("hit") as Sprite;
				buttonMode = true;
				addEventListener(Event.ADDED_TO_STAGE, initUpdate, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, clearUpdate, false, 0, true);
		}
		private function initUpdate (e:Event):void {
			stop();
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseHandler, false, 0, true);
		}
		private function clearUpdate (e:Event):void {
			stop();
			isOver = false;
			removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			removeEventListener(Event.ENTER_FRAME, update);
		}
		private function mouseHandler (e:MouseEvent):void {
				if (e.type == MouseEvent.MOUSE_OVER) {
					isOver = true;
				} else if (e.type == MouseEvent.MOUSE_OUT) {
					isOver = false;
				}
		}
		private function update (e:Event):void {
			if (isOver) {
				target.nextFrame();
			} else {
				target.prevFrame();
			}
		}
	}
	
}