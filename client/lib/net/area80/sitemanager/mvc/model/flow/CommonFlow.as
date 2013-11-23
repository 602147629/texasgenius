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

package net.area80.sitemanager.mvc.model.flow
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import net.area80.sitemanager.events.TransitionEvent;
	import net.area80.sitemanager.mvc.model.Page;
	import net.area80.sitemanager.mvc.plugins.PagePlugin;
	
	import org.osflash.signals.Signal;
	
	/**
	 * If PagePlugin.FLOW_OUT_PRELOAD_IN is set, your current page will be transitioned out before preload a new page 
	 * @author wissarut
	 * 
	 */
	public class CommonFlow extends Flow
	{

		
		public function CommonFlow()
		{
			super();
		}
		
		override public function start():void
		{
			animationCount = 1;
			if(oldPage) animationCount ++;
			
			if(crossFade) {
				oldPageTransitionOut();
				preloaderTransitionIn();
			} else {
				if(oldPage) {
					oldPageTransitionOut();
				} else {
					preloaderTransitionIn();
				}
			}
			super.start();
		}
		
		override protected function oldPageTransitionOutComplete(e:TransitionEvent):void
		{
			super.oldPageTransitionOutComplete(e);
			if(crossFade) {
				checkFirstStep();
			} else {
				preloaderTransitionIn();
			}
		}
		
		override protected function preloaderTransitionInComplete(e:TransitionEvent):void
		{
			super.preloaderTransitionInComplete(e);
			checkFirstStep();
			
		}
		
		protected function checkFirstStep ():void {
			if(animationCount==0) {
				//STEP 2
				loadNewPage();
			}
		}
		
		override protected function addPageToContainer():void
		{
			super.addPageToContainer();
			//TRANSITION STEP 2
			startStep2();
		}
		
		
		
		
		//STEP 2
		
		protected function startStep2 ():void {
			animationCount = 2;
			if(crossFade) {
				newPageTransitionIn();
				preloaderTransitionOut();
			} else {
				preloaderTransitionOut();		
			}
		}
		
		override protected function newPageTransitionInComplete(e:TransitionEvent):void
		{
			super.newPageTransitionInComplete(e);
			checkStep2();
		}
		
		override protected function preloaderTransitionOutComplete(e:TransitionEvent):void
		{
			super.preloaderTransitionOutComplete(e);
			if(crossFade) {
				checkStep2();
			} else {
				newPageTransitionIn();
			}
		}
		protected function checkStep2():void {
			if(animationCount==0) {
				flowComplete();
			}
		}
		
		
		
	}
}