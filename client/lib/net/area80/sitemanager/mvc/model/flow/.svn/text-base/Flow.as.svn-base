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
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	import net.area80.sitemanager.SiteManager;
	import net.area80.sitemanager.interfaces.view.IPreloader;
	import net.area80.sitemanager.mvc.events.PageEvent;
	import net.area80.sitemanager.events.TransitionEvent;
	import net.area80.sitemanager.mvc.events.FlowEvent;
	import net.area80.sitemanager.mvc.model.Page;
	import net.area80.sitemanager.mvc.model.enum.DepthStack;
	
	/**
	 * Dispatchs when transition flow is complete.
	 * @eventType net.area80.sitemanager.mvc.events.FlowEvent.TRANSITION_COMPLETE
	 */
	[Event(name="transitionComplete", type="net.area80.sitemanager.mvc.events.FlowEvent")]

	public class Flow extends EventDispatcher
	{
		public static var VERBOSE:Boolean = false;
		
		protected var newPage:Page;
		protected var oldPage:Page;
		protected var preloader:IPreloader;
		protected var crossFade:Boolean = false;
		protected var container:DisplayObjectContainer;
		protected var depthControl:String;
		protected var animationCount:uint=0;
		
		protected var progressCache:ProgressEvent;
		
		public function Flow()
		{
			
		}
		/**
		 * initialize flow before call start
		 * @param $container
		 * @param $newPage
		 * @param $preloader
		 * @param $oldPage
		 * @param $depthControl see PagePlugin.DEPTH_*
		 * @param $crossFade
		 * 
		 */
		public function initFlow ($container:DisplayObjectContainer, 
								  $newPage:Page, $preloader:IPreloader, 
								  $oldPage:Page = null, 
								  $depthControl:String = "stack", 
								  $crossFade:Boolean = false):void 
		{
			container = $container;
			
			newPage = $newPage;
			oldPage = $oldPage;
			preloader = $preloader;
			depthControl = $depthControl;
			crossFade = $crossFade;
		}
		/**
		 * Override this function to start process 
		 * 
		 */
		public function start ():void {
			
		}
		protected function flowComplete ():void {
			log("Flow Completed");
			dispatchEvent(new FlowEvent(FlowEvent.TRANSITION_COMPLETE));
			
		}
		protected function loadNewPage ():void {
			newPage.addEventListener(ProgressEvent.PROGRESS, updateProgress);
			newPage.addEventListener(PageEvent.CONTENT_INIT, contentReadyHandler);
			preloader.setObjectToLoad(newPage);
			newPage.loadContent();
		}
		
		protected function contentReadyHandler(event:PageEvent):void
		{
			addPageToContainer();
		}
		
		protected function addPageToContainer ():void {
			log("Page loaded and added to container.");
			if(depthControl==DepthStack.STACK) {
				container.addChild(newPage.content);
			} else if(depthControl==DepthStack.UNDER) {
				container.addChildAt(newPage.content,0);
			}
		}
		
		protected function updateProgress(e:ProgressEvent):void
		{
			progressCache = e;
			IPreloader(preloader).progressHandler(e);
		}
		
		protected function oldPageTransitionOut ():void {
			
			if(oldPage){
				oldPage.addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE,oldPageTransitionOutComplete);
				oldPage.transitionOut();
			}
		}
		protected function oldPageTransitionOutComplete (e:TransitionEvent):void {
			log("Old page transition out complete.");
			oldPage.removeEventListener(e.type,oldPageTransitionOutComplete);
			container.removeChild(oldPage.content);
			animationCount--;
		}
		
		protected function preloaderTransitionIn ():void {
			preloader.addEventListener(TransitionEvent.TRANSITION_IN_COMPLETE,preloaderTransitionInComplete);
			preloader.transitionIn();
		}
		protected function preloaderTransitionOut ():void {
			//dispatchs complete handler via progress event
			var p:ProgressEvent = (progressCache) ? progressCache : new ProgressEvent(ProgressEvent.PROGRESS);
			p.bytesTotal = p.bytesLoaded = (progressCache) ? progressCache.bytesTotal : newPage.content.loaderInfo.bytesTotal;
			IPreloader(preloader).progressHandler(p);
			
			preloader.addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE,preloaderTransitionOutComplete);
			preloader.transitionOut();
		}
		protected function preloaderTransitionOutComplete (e:TransitionEvent):void {
			log("Preloader transition out complete.");
			preloader.removeEventListener(e.type,preloaderTransitionOutComplete);
			animationCount--;
		}
		protected function preloaderTransitionInComplete (e:TransitionEvent):void {
			log("Preloader transition in complete.");
			preloader.removeEventListener(e.type,preloaderTransitionInComplete);
			animationCount--;
		}
		
		protected function newPageTransitionIn ():void {
			newPage.addEventListener(TransitionEvent.TRANSITION_IN_COMPLETE,newPageTransitionInComplete);
			newPage.transitionIn();
		}
		

		protected function newPageTransitionInComplete (e:TransitionEvent):void {
			log("New page transition in complete.");
			newPage.removeEventListener(e.type,newPageTransitionInComplete);
			animationCount--;
		}
		
		protected function log (msg:String):void {
			if(VERBOSE) SiteManager.log(this+" "+msg);
		}
	}
}