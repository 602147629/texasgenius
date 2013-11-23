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

package net.area80.sitemanager.mvc.view.swf
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import net.area80.sitemanager.SiteManager;
	import net.area80.sitemanager.events.TransitionEvent;
	import net.area80.sitemanager.interfaces.view.IPreloader;

	
	public class PreloaderSWF extends Sprite
	{
		protected var _preloader:Sprite;
		protected function get preloader ():IPreloader {			return _preloader as IPreloader;		}
		
		protected var shellPath:String;
		protected var ldr:Loader;
		protected var crossFade:Boolean;
		
		/**
		 * 
		 * @param $shellSwfPath
		 * @param $preload Sprite which must implements IPreloader
		 * @param $crossFade If set to true preloader and the content will use cross-fade transition when the content loaded
		 * 
		 */
		public function PreloaderSWF($shellSwfPath:String, $preload:Sprite, $crossFade:Boolean=true)
		{
			super();
			SiteManager.log("[PreloaderSWF] is loaded");
			shellPath = $shellSwfPath;
			if(!($preload is IPreloader)) {
				throw new ArgumentError("$preload must implements IPreloader");
				return;
			}
			_preloader = $preload;
			crossFade = $crossFade;
			if(stage) {   
				initStage(); 
			} else {
				addEventListener(Event.ADDED_TO_STAGE,initStage);
			}
		}
		
		protected function initStage (e:Event=null):void {
			stage.addChild(_preloader);
			
			preloader.addEventListener(TransitionEvent.TRANSITION_IN_COMPLETE, onTransitionIn);
			preloader.transitionIn();
		}
		protected function onTransitionIn(event:Event):void
		{
			composeLoader();
		}
		protected function composeLoader ():void {
			ldr = new Loader();
			
			var c:LoaderContext = new LoaderContext(false);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			ldr.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, loadErrorHandler);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			ldr.load(new URLRequest(shellPath),c);
		}
		
		protected function loadErrorHandler(event:Event):void
		{
			SiteManager.error(this, "load error, try to load again...");
			composeLoader();
		}
		protected function loadProgressHandler (e:ProgressEvent):void {
			preloader.progressHandler(e);
		}
		protected function loadCompleteHandler ($e:Event):void {
			
			preloader.addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE, onTransitionOut);
			if(crossFade) addChildAt(ldr.content,0);
			preloader.transitionOut();
			
		}
		protected function onTransitionOut(event:Event):void
		{
			stage.removeChild(_preloader);
			_preloader=null;
			if(!crossFade) addChild(ldr.content);
			
		}
	}
}