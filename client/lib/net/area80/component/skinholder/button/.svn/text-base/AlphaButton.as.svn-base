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
	
	public class AlphaButton extends UIButton
	{
		public var rollOverAlpha:Number = .6;
		private var isOver:Boolean;
		private var setAlpha:Number = 1;
		
		
		public function AlphaButton($skin:Sprite)
		{
			super($skin);
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		override public function set focus(value:Boolean):void
		{
			if(value==focus) return;
			super.focus = value;
			if(!value){
				construct();
				skin.alpha = 1;
				
			} else {
				dispose();
				skin.alpha = .4;
				
			}
		}
		
		override public function set enabled (b:Boolean):void {
			super.enabled = b;
			if(b){
				construct();
				skin.alpha = 1;
			} else {
				dispose();
				skin.alpha = 1;
			}
			
		} 
		protected override function construct (e:Event=null):void {
			addEventListener(Event.ENTER_FRAME, update);
		}
		protected override function dispose (e:Event=null):void {
			removeEventListener(Event.ENTER_FRAME, update);
		}
		private function update (e:Event):void {
			skin.alpha += (setAlpha -skin.alpha) * 0.4;
		}
		
		override protected function mouseDownHandler(event:MouseEvent):void
		{
			// TODO Auto Generated method stub
			super.mouseDownHandler(event);
			
			if (_isOver) {
				setAlpha = rollOverAlpha - 0.2;
			}
		}
		
		override protected function mouseUpHandler(event:MouseEvent):void
		{
			// TODO Auto Generated method stub
			super.mouseUpHandler(event);
			
			if (_isOver) {
				mouseHandler(new MouseEvent(MouseEvent.ROLL_OVER));
			}
		}
		
		override protected function rollOutHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			super.rollOutHandler(e);
			
			setAlpha = 1;
		}
		
		override protected function rollOverHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			super.rollOverHandler(e);
			
			setAlpha = rollOverAlpha;

		}
		
		private function mouseHandler (e:MouseEvent):void {
			if(focus) return;
			if (e.type == MouseEvent.ROLL_OVER) {
				setAlpha = rollOverAlpha;
				isOver = true;
			} else if (e.type == MouseEvent.ROLL_OUT) {
			
				isOver = false;
			}
		}
		private function downHandler (e:MouseEvent):void  {
			if (isOver) {
				setAlpha = rollOverAlpha - 0.2;
			}
		}
		private function upHandler (e:MouseEvent):void  {
			if (isOver) {
				mouseHandler(new MouseEvent(MouseEvent.ROLL_OVER));
			}
		}
	}
}