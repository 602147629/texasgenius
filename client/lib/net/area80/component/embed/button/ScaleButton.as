﻿package net.area80.component.embed.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* ScaleButton
	* @author Wissarut Pimanmassuriya
	*/
	public class ScaleButton extends MovieClip
	{
		public var rollOverScale:Number = 1.1;
		private var isOver:Boolean = false;
		private var setScale:Number = 1;
		
		public function ScaleButton ():void {
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
			scaleX += (setScale - scaleX) * 0.3;
			scaleY = scaleX;
		}
		private function mouseHandler (e:MouseEvent):void {
				if (e.type == MouseEvent.ROLL_OVER) {
					setScale = rollOverScale;
					isOver = true;
				} else if (e.type == MouseEvent.ROLL_OUT) {
					setScale = 1;
					isOver = false;
				}
		}
		private function downHandler (e:MouseEvent):void {
				if (isOver) {
					setScale = rollOverScale +0.1;
				}
		}
		private function upHandler (e:MouseEvent):void {
				if (isOver) {
					mouseHandler(new MouseEvent(MouseEvent.ROLL_OVER));
				}
		}
	}
	
}