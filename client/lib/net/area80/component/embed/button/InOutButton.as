package net.area80.component.embed.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	* InOutButton
	* @author Wissarut Pimanmassuriya
	*/
	public class InOutButton extends MovieClip
	{
		private var isOver:Boolean = false;
		private var _needStop:Boolean = false;
		
		public function InOutButton ():void {
				if (getChildByName("hit")) hitArea = getChildByName("hit") as Sprite;
				buttonMode = true;
				addEventListener(Event.ADDED_TO_STAGE, initUpdate, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, clearUpdate, false, 0, true);
		}

		private function initUpdate (e:Event):void {
			super.stop();
			_needStop = false;
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler, false, 0, true);
		}
		private function clearUpdate (e:Event):void {
			super.stop();
			_needStop = false;
			isOver = false;
			removeEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			removeEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			removeEventListener(Event.ENTER_FRAME, update);
		}
		private function mouseHandler (e:MouseEvent):void {
				if (e.type == MouseEvent.ROLL_OVER) {
					isOver = true;
					play();
				} else if (e.type == MouseEvent.ROLL_OUT) {
					isOver = false;
					play();
				}
		}
		public override function stop ():void {
				if (isOver) {
					super.stop();
				}
		}
		private function update (e:Event):void {
			if (currentFrame == 1) {
				if (isOver) {
						play();
				} else {
						super.stop();
				}
			}
		}
	}
	
}