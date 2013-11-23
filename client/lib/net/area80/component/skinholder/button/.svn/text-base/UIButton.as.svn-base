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
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import net.area80.component.skinholder.core.SkinHolderComponent;

	public class UIButton extends SkinHolderComponent
	{
		protected var _enabled:Boolean = true;
		protected var _focus:Boolean = false;
		protected var _hitObject:Sprite;
		protected var _mouseIsDown:Boolean = false;
		protected var _isOver:Boolean = false;

		public function UIButton($skin:Sprite)
		{
			super($skin);

			if (skin.getChildByName("hit")) {
				_hitObject = Sprite(skin.getChildByName("hit"));
				hitArea = _hitObject;
				skin.mouseChildren = false;
				skin.mouseEnabled = false;

				addChild(_hitObject);
			} else {
				_hitObject = skin;
			}

			enabled = true;
			_hitObject.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			_hitObject.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			_hitObject.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_hitObject.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

		}


		protected function mouseUpHandler(event:MouseEvent):void
		{
			_mouseIsDown = false;
		}

		protected function mouseDownHandler(event:MouseEvent):void
		{
			_mouseIsDown = true;
		}

		protected function rollOverHandler(e:MouseEvent):void
		{
			_isOver = true;
			if (enabled) {
				//Mouse.cursor = MouseCursor.BUTTON;
			}
		}

		protected function rollOutHandler(e:MouseEvent):void
		{
			_isOver = false;
			mouseUpHandler(new MouseEvent(MouseEvent.MOUSE_UP));
			//Mouse.cursor = MouseCursor.AUTO;
		}

		public function get focus():Boolean
		{
			return _focus;
		}

		public function set focus(value:Boolean):void
		{
			_focus = value;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;

			_hitObject.mouseChildren = value;
			_hitObject.mouseEnabled = value;
			_hitObject.buttonMode = value;
			_hitObject.useHandCursor = value;
		}

	}
}
