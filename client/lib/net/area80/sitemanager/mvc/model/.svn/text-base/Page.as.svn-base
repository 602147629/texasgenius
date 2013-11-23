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

package net.area80.sitemanager.mvc.model
{

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import net.area80.sitemanager.interfaces.commandmap.IPageCommandMap;
	import net.area80.sitemanager.interfaces.view.IPage;
	import net.area80.sitemanager.interfaces.view.ITransitionalDisplay;
	import net.area80.sitemanager.mvc.command.ChangePageCommand;
	import net.area80.utils.LoaderUtils;
	
	/**
	 * Dispatchs when content is initialized and ready to transition.
	 * @eventType net.area80.sitemanager.mvc.events.PageEvent.CONTENT_INIT
	 */
	[Event(name="contentInit", type="net.area80.sitemanager.mvc.events.PageEvent")]
	
	/**
	 * Dispatchs while loading content.
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	public class Page extends CommandMap implements IPageCommandMap, ITransitionalDisplay
	{	
	
		protected var ldr:Loader;
		
		
		public function Page($source:*, $name:String, $params:Object=null)
		{
			super($source,$name,$params);
		}

		protected override function dispose (e:Event):void {
			if(content) {
				if(content is MovieClip) {
					try{
					MovieClip(content).stop();
					} catch (e:Error){}
				}
			}
			
			if(ldr) {
				try {
					ldr.close();
				} catch (e:Error) {}
				try {
					ldr.unload();
				} catch (e:Error) {}
			}
			
		}
		
		
		public override function loadContent ():void {
			if(source is Sprite) {
				initContent(source);
			} else if(source is Function) {
				try { 
					initContent(source() as Sprite);
				} catch (e:Error) {
					error("source function must return sprite");
				}
			} else if (source is String) {
				ldr = new Loader();

				var c:LoaderContext = new LoaderContext(false);
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
				ldr.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				ldr.load(new URLRequest(source),c);
			}
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			if(ldr.content && ldr.content is Sprite && ldr.content is IPage) {
				try {
					initContent(Sprite(ldr.content));
				} catch (e:Error) {
					error("Content cannot be initialized");
				}
			} else {
				error("Content must be implement IPage and extends Sprite");
			}
			
		}
		public function changePage($pageName:String, $params:Object=null):void
		{
			var cmd:ChangePageCommand = new ChangePageCommand($pageName, $params);
			cmd.exec();
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			error("IO_ERROR");
			
		}
		
		protected function asyncErrorHandler(event:Event):void
		{
			error("ASYNC_ERROR");
		}
		
		
		
	}
}