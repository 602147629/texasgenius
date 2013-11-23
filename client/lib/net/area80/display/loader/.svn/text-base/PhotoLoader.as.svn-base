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

package net.area80.display.loader
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.ByteArray;

	import org.osflash.signals.Signal;

	/**
	 * Dispatchs when content is loaded and ready to display
	 */
	[Event(name = "complete", type = "flash.events.Event")]

	/**
	 * Forward from URLLoader
	 * @see flash.events.ProgressEvent
	 */
	[Event(name = "progress", type = "flash.events.ProgressEvent")]

	/**
	 * Forward from URLLoader
	 * @see flash.events.HTTPStatusEvent
	 */
	[Event(name = "httpStatus", type = "flash.events.HTTPStatusEvent")]

	/**
	 * Load image (jpg,png,gif) in bynary format to container. You can force image to be scaled based on height or/and width size.
	 * However, if you want to fill image in a box or want to display in exactly width and height property, use ImageBox instead.
	 *
	 * @usage
	 *
	 * <code>
	 * var ploader:PhotoLoader = new PhotoLoader("image.jpg",200);//this will force image width to 200 pixels and scale its height automatically.
	 * //init listeners
	 * ploader.addEventListener(Event.COMPLETE, completeHandler);
	 * ploader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	 * ploader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
	 * //or use signal to get all event
	 * ploader.SIGNAL_EVENT.add(someFunction);
	 * //start load
	 * ploader.load();
	 * </code>
	 *
	 * @author wissarut
	 * @version 2.0
	 */
	public class PhotoLoader extends Sprite
	{
		/**
		 * Throw error exception, if content is not Bitmap.
		 */
		public static var THROW_ERROR:Boolean = true;

		protected var path:String;
		protected var ldr:Loader;
		protected var content:Bitmap;
		protected var w:uint = 0;
		protected var h:uint = 0;
		protected var ul:URLLoader;
		protected var _smoothing:Boolean = true;

		protected var _scale:Number = 1;
		protected var isServerError:Boolean = false;

		/**
		 * Dispatch all event.
		 */
		public var SIGNAL_EVENT:Signal = new Signal(PhotoLoader, Event);


		/**
		 * call photoloader.load(); to start
		 * @param $path can be "" if you want to set a bitmapdata to it with setContent
		 * @param $w Fix-width of the content. If both width and height are set, content will be reseize prior to smaller side.
		 * @param $h Fix-height of the content. If both width and height are set, content will be reseize prior to smaller side.
		 *
		 */
		public function PhotoLoader($path:String = "", $w:uint = 0, $h:uint = 0)
		{
			w = $w;
			h = $h;

			path = $path;
			addEventListener(Event.ADDED_TO_STAGE, construct);

		}

		/**
		 * Set Bitmap to be the content without using load, event complete will be dispatched also.
		 * @param bmp
		 *
		 */
		public function setContent(bmp:Bitmap):void
		{

			content = bmp;
			if (_smoothing)
				content.smoothing = true;
			addChild(content);
			composeContent();
			dispatchAllEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Scale of content
		 * @return
		 *
		 */
		public function get scale():Number
		{
			return _scale;
		}

		/**
		 * Load content (Startup function)
		 *
		 */
		public function load():void
		{
			composeBinaryLoader();
		}

		/**
		 * This will called automatically, when content is removed from display stage or when http error 404,500 event is received.
		 *
		 */
		public function dispose():void
		{
			//	trace("dispose");
			removeEventListener(Event.ADDED_TO_STAGE, construct);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			clearListener();
			disposeLoader();
			disposeURLLoader();
		}

		public function get loader():Loader
		{
			return ldr;
		}

		public function get urlLoader():URLLoader
		{
			return ul;
		}

		public function get smoothing():Boolean
		{
			return _smoothing;
		}

		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			if (content)
				content.smoothing = value;
		}

		protected function dispatchAllEvent(event:Event):void
		{

			if (event.type!=IOErrorEvent.IO_ERROR) {
				dispatchEvent(event);
			}
			SIGNAL_EVENT.dispatch(this, event);
		}

		protected function construct(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, construct);
			addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
		}


		protected function composeBinaryLoader():void
		{
			clearListener();

			ul = new URLLoader();

			ul.dataFormat = URLLoaderDataFormat.BINARY;

			ul.load(new URLRequest(path));

			ul.addEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
			ul.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			ul.addEventListener(Event.COMPLETE, binaryLoadedHandler);
			ul.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			ul.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		protected function securityErrorHandler(event:Event):void
		{
			Console.dir(event);
			//dispatchAllEvent(event);
		}

		protected function httpStatusHandler(event:HTTPStatusEvent):void
		{
			if (event.status==404) {
				//not found
				isServerError = true;
			} else if (event.status==500) {
				//internal server error
				isServerError = true;
			}
			//trace(this.name+" "+event.status);
			dispatchAllEvent(event);
		}

		protected function binaryLoadedHandler(event:Event):void
		{
			//trace(this.name+" "+event);
			composeBytesLoader(URLLoader(event.currentTarget).data as ByteArray);
		}

		protected function composeBytesLoader(b:ByteArray):void
		{

			ldr = new Loader();

			//var lc:LoaderContext = new LoaderContext(true);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderLoadErrorHandler);
			try {
				ldr.loadBytes(ul.data as ByteArray);
			} catch (e:Error) {
				onLoaderLoadErrorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			}
		}

		protected function progressHandler(e:ProgressEvent):void
		{
			dispatchAllEvent(e);
		}

		protected function clearListener():void
		{
			if (ul) {
				ul.removeEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
				ul.removeEventListener(Event.COMPLETE, binaryLoadedHandler);
				ul.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				ul.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			}
			if (ldr) {
				ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadCompleteHandler);
				ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderLoadErrorHandler);
			}
		}

		protected function onLoaderLoadErrorHandler(event:Event):void
		{
			dispatchAllEvent(event);
			dispose();
		}

		protected function onLoadErrorHandler(event:Event):void
		{
			if (!isServerError) {
				composeBinaryLoader();
			} else {
				dispatchAllEvent(event);
				dispose();
			}
		}

		protected function onLoadCompleteHandler(e:Event):void
		{
			try {
				if (!(ldr.content is Bitmap)) {
					throw new Error(this+" Content is not Bitmap.");
				}
			} catch (e:Error) {
				if (THROW_ERROR)
					throw e;
				return;
			}
			setContent(ldr.content as Bitmap);
		}

		/**
		 * Main engine
		 *
		 */
		protected function composeContent():void
		{
			_scale = 1;

			if (w!=0||h!=0) {
				if (w==0&&h!=0) {
					//height priority
					_scale = h/content.height;
				} else if (h==0&&w!=0) {
					//width priority
					_scale = w/content.width;
				} else {
					//height & width priority
					_scale = Math.min(w/content.width, h/content.height);
				}
			}

			content.scaleX = content.scaleY = _scale;
		}


		protected function removeHandler(e:Event):void
		{
			dispose();
		}

		protected function disposeURLLoader():void
		{
			if (!ul)
				return;
			try {
				ul.close();
			} catch (e:Error) {
			}

		}

		protected function disposeLoader():void
		{
			if (!ldr)
				return;
			try {
				ldr.close();
			} catch (e:Error) {
			}
			try {
				ldr.unload();
			} catch (e:Error) {
			}
		}

	}
}
