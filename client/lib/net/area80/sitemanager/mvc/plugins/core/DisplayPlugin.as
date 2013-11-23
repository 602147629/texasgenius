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

package net.area80.sitemanager.mvc.plugins.core
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import net.area80.sitemanager.mvc.plugins.ShellPlugin;
	import net.area80.sitemanager.mvc.view.swf.ShellSWF;
	
	public class DisplayPlugin extends ShellPlugin
	{
		private var freezeClip:Sprite;
		private var freezeCount:uint=0;
		protected var container:Sprite;
		
		protected function get stage ():Stage {
			return container.stage;
		}
		
		public function DisplayPlugin($container:Sprite)
		{
			container = $container;
			initContainer();
			super();
		}
		
		protected function childAddedHandler($e:Event):void
		{
			if($e.currentTarget!=freezeClip){
				//freeze must be on top of any display
				container.addChild(freezeClip).name = "freezeClip";
			}
			
		}
		/**
		 * 
		 * @return Boolean indicate freeze state of display content
		 * 
		 */
		protected function get isFreeze ():Boolean {	return freezeClip.visible;		}
		/**
		 * Disable mouse interaction for display container **you must call unFreeze every time you freeze something
		 * 
		 */
		protected function freeze ():void {			freezeCount++;	freezeClip.visible = true;		}
		/**
		 * Enable mouse interaction for display container **call this every time you call freeze
		 * 
		 */
		protected function unFreeze ():void {		
			if(freezeCount>0)freezeCount--;
			freezeCount = Math.max(0,freezeCount);
			if(freezeCount==0) freezeClip.visible = false;		
		}
		private function initContainer ():void {
			freezeClip = new Sprite();
			freezeClip.graphics.beginFill(0xFF0000,0);
			freezeClip.graphics.drawRect(0,0,100,100);
			freezeClip.visible = false;
			container.addChild(freezeClip).name = "freezeClip";
			if(stage) {
				initStage();
			} else {
				container.addEventListener(Event.ADDED_TO_STAGE, initStage);
			}
			container.addEventListener(Event.ADDED, childAddedHandler);
		}
		
		private function initStage($e:Event=null):void
		{
			container.removeEventListener(Event.ADDED_TO_STAGE, initStage);
			container.addEventListener(Event.REMOVED_FROM_STAGE, stageBlur);
			stage.addEventListener(Event.RESIZE, resizeFreezeClip);
			resizeFreezeClip();
		}
		
		private function stageBlur($e:Event=null):void
		{
			container.removeEventListener(Event.REMOVED_FROM_STAGE, stageBlur);
			container.addEventListener(Event.ADDED_TO_STAGE, initStage);
			stage.removeEventListener(Event.RESIZE, resizeFreezeClip);
		}
		
		private function resizeFreezeClip($e:Event=null):void
		{
			freezeClip.width = stage.stageWidth;
			freezeClip.height = stage.stageHeight;
			freezeClip.x = -container.x;
			freezeClip.y = -container.y;
		}

	}
}