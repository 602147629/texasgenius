package net.area80.component.embed.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* ElasticButton
	* @author Wissarut Pimanmassuriya
	*/
	public class ElasticButton extends MovieClip
	{
		protected var isOver:Boolean = false;
		protected var _needStop:Boolean = false;
		protected var active:Boolean = false;
		protected var spring:Number = .8;
		protected var friction:Number = .7;
		protected var max_drag:Number = .3;
		protected var init_x:Number = 0;
		protected var init_y:Number = 0;
		protected var vx:Number = 0;
		protected var vy:Number = 0;
		private var isButtonOver:Boolean = false;
		
		public function ElasticButton ():void {
				if (getChildByName("hit")) hitArea = getChildByName("hit") as Sprite;
				buttonMode = true;
				addEventListener(Event.ADDED_TO_STAGE, initUpdate, false, 0, true);
				addEventListener(Event.REMOVED_FROM_STAGE, clearUpdate, false, 0, true);
				addEventListener(MouseEvent.ROLL_OVER, doOverHandler);
				addEventListener(MouseEvent.ROLL_OUT, doOutHandler);
		}
		public override function set x (thex:Number):void {
			init_x = x;
			super.x = thex;
		}
		public override function set y (they:Number):void {
			init_y = y;
			super.y = they;
		}

		private function initUpdate (e:Event):void {
			init_x = x;
			init_y = y;
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		private function clearUpdate (e:Event):void {
			removeEventListener(Event.ENTER_FRAME, update);
		}
		private function doOverHandler (e:MouseEvent):void {
			isButtonOver = true;
		}
		private function doOutHandler (e:MouseEvent):void {
			isButtonOver = false;
		}
		private function update (e:Event):void {
				var nX:Number;
				var nY:Number;
				
				//if (hitTestPoint(parent.mouseX, parent.mouseY, true)) {
				if (isButtonOver) {
					nX = init_x - (init_x - parent.mouseX) * max_drag;
					nY = init_y - (init_y - parent.mouseY) * max_drag;
					super.x = x + ((nX - x) * spring);
					super.y = y + ((nY - y) * spring);
				} else {
					nX = (init_x - x) * spring;
					nY = (init_y - y) * spring;
					
					vx = vx+nX;
					vy = vy+nY;
					vx = vx*friction;
					vy = vy * friction;
					
					super.x = x+vx;
					super.y = y+vy;
				}
		
		}
	}
	
}