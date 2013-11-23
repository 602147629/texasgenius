/*
Copyright © 2008-2011, Area80 Co.,Ltd.
All rights reserved.

Facebook: http://www.fb.com/Area80/
Website: http://www.area80.net/
Docs: http://www.area80.net/sitemanager/


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

package net.area80.sitemanager.mvc.view.freezeclip
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	
	import gs.TweenLite;
	
	/**
	 * FreezeClip
	 * @author Wissarut Pimanmassuriya
	 */
	public class FreezeClip extends Sprite
	{
		protected var freezeColor:int;
		protected var freezeAlpha:Number;
		protected var gp:Sprite;

		
		public function FreezeClip (color:int = 0x000000, alpha:Number = 0):void {
			freezeColor = color;
			freezeAlpha = alpha;
			gp = new Sprite();
			addChild(gp);
			addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);	
			addEventListener(Event.REMOVED_FROM_STAGE, dispose, false, 0, true);	
		}
		public function show ($fadeDuration:Number=0):void {
			if($fadeDuration>0) {
				alpha = 0;
				new TweenLite(this, $fadeDuration, { alpha:1 } );
			} else {
				alpha = 1;
			}
			visible = true;
		}
		public function hide ($fadeDuration:Number=0):void {
			if($fadeDuration>0) {
				new TweenLite(this, $fadeDuration, { alpha:0 } );
			} else {
				alpha = 0;
			}
			visible = false;
		}
		private function resize (e:Event):void {
			update();
		}
		protected function update ():void {
			gp.width = stage.stageWidth;
			gp.height = stage.stageHeight;
		}
		protected function redraw ():void {
			gp.graphics.clear();
			gp.graphics.beginFill(freezeColor, freezeAlpha);
			gp.graphics.drawRect(0, 0,stage.stageWidth, stage.stageHeight);
		}
		protected function create (e:Event):void {
			stage.addEventListener(Event.RESIZE, resize);
			redraw();
			update();
		}
		protected function dispose (e:Event):void {
			stage.removeEventListener(Event.RESIZE, resize);
			removeEventListener(Event.ADDED_TO_STAGE, create);	
			removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			graphics.clear();
		}
	}
	
}