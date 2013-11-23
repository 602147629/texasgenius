/*
Copyright © 2008-2011, Area80 Co.,Ltd.
All rights reserved.

Facebook: http://www.fb.com/Area80/
Website: http://www.area80.net/


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of Area80 Incorporated nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package net.area80.component.skinholder.button
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ElasticButton extends UIButton
	{

		protected var isOver:Boolean = false;
		protected var _needStop:Boolean = false;
		protected var active:Boolean = false;
		protected var spring:Number = .7;
		protected var friction:Number = .8;
		protected var max_drag:Number = .3;
		protected var init_x:Number = 0;
		protected var init_y:Number = 0;
		protected var vx:Number = 0;
		protected var vy:Number = 0;
		private var isButtonOver:Boolean = false;
		private var centerSprite:Sprite;



		public function ElasticButton($skin:Sprite)
		{
			super($skin);
			centerSprite = new Sprite();
			addChild(centerSprite);
			centerSprite.addChild(skin);
			skin.x = -skin.width * .5;
			skin.y = -skin.height * .5;
			centerSprite.x = -skin.x;
			centerSprite.y = -skin.y;
			init_x = centerSprite.x;
			init_y = centerSprite.y;
			skin = centerSprite;
			enabled = true;
		}


		private function initUpdate(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}

		private function clearUpdate(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, update);
		}

		protected override function rollOverHandler(e:MouseEvent):void
		{
			isButtonOver = true;
		}

		protected override function rollOutHandler(e:MouseEvent):void
		{
			isButtonOver = false;
		}

		private function update(e:Event):void
		{
			var nX:Number;
			var nY:Number;

			//if (hitTestPoint(parent.mouseX, parent.mouseY, true)) {
			if (isButtonOver) {
				nX = init_x - (init_x - mouseX) * max_drag;
				nY = init_y - (init_y - mouseY) * max_drag;
				skin.x += (nX - skin.x) * spring;
				skin.y += (nY - skin.y) * spring;
			} else {
				nX = (init_x - skin.x) * spring;
				nY = (init_y - skin.y) * spring;

				vx = vx + nX;
				vy = vy + nY;
				vx = vx * friction;
				vy = vy * friction;

				skin.x = skin.x + vx;
				skin.y = skin.y + vy;
			}

		}


		override public function set enabled(b:Boolean):void
		{
			super.enabled = b;
			if (b) {
				construct();
			} else {
				dispose();
			}

		}

		protected override function construct(e:Event = null):void
		{
			addEventListener(Event.ENTER_FRAME, update);
		}

		protected override function dispose(e:Event = null):void
		{
			removeEventListener(Event.ENTER_FRAME, update);
		}


	}
}
