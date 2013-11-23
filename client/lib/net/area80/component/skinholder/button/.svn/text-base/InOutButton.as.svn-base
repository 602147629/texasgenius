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
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class InOutButton extends UIButton
	{
		protected var isOver:Boolean = false;
		public function InOutButton($skin:MovieClip)
		{
			super($skin);
			initFrame(); 
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
		}
		
		override public function set focus(value:Boolean):void
		{
			if(value==focus) return;
			super.focus = value;
			if(focus) {
				isOver = true; 
				skinClip.play();
			} else {
				isOver = false;
				skinClip.play();
			}
		}
		
		override protected function rollOutHandler(e:MouseEvent):void
		{
			if(_focus) return;
			isOver = false;
			super.rollOutHandler(e);
			skinClip.play();
		}
		
		override protected function rollOverHandler(e:MouseEvent):void
		{
			if(_focus) return;
			isOver = true; 
			super.rollOverHandler(e);
			skinClip.play();
		}
		
		protected function get skinClip():MovieClip {return skin as MovieClip;}
		
		protected function initFrame ():void {
			var labels:Array = skinClip.currentLabels;
			var standByFrame:int = -1;
			var inFrame:int = -1;
			var outFrame:int = -1;
			for(var i:uint =0;i<labels.length;i++) {
				var label:FrameLabel = labels[i] as FrameLabel;
				if(label.name=="standby") standByFrame = label.frame;
				if(label.name=="in") inFrame = label.frame;
				if(label.name=="out") outFrame = label.frame;
			}
			if(standByFrame != -1 && inFrame !=-1 && outFrame != -1) {
				skinClip.addFrameScript(0,startFrameHandler);
				skinClip.addFrameScript(standByFrame-1,standbyFrameHandler);
				skinClip.addFrameScript(skinClip.totalFrames-1,endFrameHandler);
				skinClip.gotoAndStop(1);
			} else {
				throw new Error(this+" Movieclip content must have 3 frame labels (in, standby, out)");
			}
		}
		protected function startFrameHandler ():void {

			if(isOver) {
				skinClip.play();
			} else {
				skinClip.stop();
			}
		}

		protected function standbyFrameHandler ():void {
			if(!isOver) {
				skinClip.play();
			} else {
				skinClip.stop();
			}
		}
		protected function endFrameHandler ():void {
			
			skinClip.gotoAndStop(1);
		}
	}
}