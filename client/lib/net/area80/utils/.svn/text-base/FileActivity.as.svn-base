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

package net.area80.utils
{

	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.adobejson.AdobeJSON;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import ru.inspirit.net.MultipartURLLoader;

	/**
	 * Load/Upload/Download files
	 * @author wissarut
	 *
	 */
	public class FileActivity
	{
		private static const TYPE_STRING:String = "string";
		private static const TYPE_XML:String = "xml";
		private static const TYPE_JSON:String = "json";
		private static const completeActivities:Dictionary = new Dictionary();

		/**
		 * Download file from server, this function must be call in the click hander after user perform an action with a button.
		 * @param $uri link of the file
		 * @return If download can be start, returns true.
		 *
		 */
		public static function downloadFile($uri:String):Boolean
		{
			var request:URLRequest = new URLRequest($uri);
			var localRef:FileReference = new FileReference();

			try {
				// Prompt and downlod file  
				localRef.download(request);
				return true;
			} catch (error:Error) {
				trace("Unable to download file.");
			}
			return false;
		}

		public static function uploadBitmapAsJPG($bmp:BitmapData, $uri:String, $quality:uint = 80, $callBack:Function = null, $postVariables:URLVariables = null):URLLoader
		{
			var encoder:JPGEncoder = new JPGEncoder($quality);
			var bmpInBytes:ByteArray = encoder.encode($bmp);
			return uploadBynaryImage($uri, bmpInBytes, $callBack, "image/jpeg", $postVariables);
		}

		public static function uploadBitmapAsPNG($bmp:BitmapData, $uri:String, $callBack:Function = null, $postVariables:URLVariables = null):URLLoader
		{
			var bmpInBytes:ByteArray = PNGEncoder.encode($bmp);
			return uploadBynaryImage($uri, bmpInBytes, $callBack, "image/png", $postVariables);
		}

		public static function uploadMultipleBitmapAsJPG($bmps:Vector.<BitmapData>, $uri:String, $quality:uint = 80, $callBack:Function = null, $postVariables:URLVariables = null):URLLoader
		{
			var encoder:JPGEncoder = new JPGEncoder($quality);
			var bmpInBytesList:Vector.<ByteArray> = new Vector.<ByteArray>;
			var types:Array = [];
			for (var i:uint = 0; i<$bmps.length; i++) {
				var bmpInBytes:ByteArray = encoder.encode($bmps[i]);
				types.push("image/jpeg");
				bmpInBytesList.push(bmpInBytes);
			}
			return uploadMultipleBynaryImage($uri, bmpInBytesList, types, $callBack, $postVariables);
		}

		public static function uploadMultipleBitmapAsPNG($bmps:Vector.<BitmapData>, $uri:String, $quality:uint = 80, $callBack:Function = null, $postVariables:URLVariables = null):URLLoader
		{
			var bmpInBytesList:Vector.<ByteArray> = new Vector.<ByteArray>;
			var types:Array = [];
			for (var i:uint = 0; i<$bmps.length; i++) {
				var bmpInBytes:ByteArray = PNGEncoder.encode($bmps[i]);
				types.push("image/png");
				bmpInBytesList.push(bmpInBytes);
			}
			return uploadMultipleBynaryImage($uri, bmpInBytesList, types, $callBack, $postVariables);
		}

		public static function uploadMultipleBynaryImage($uri:String, $data:Vector.<ByteArray>, $contentTypes:Array, $completeHandler:Function = null, $postVariables:URLVariables = null):URLLoader
		{

			var ml:MultipartURLLoader = new MultipartURLLoader();
			ml.dataFormat = URLLoaderDataFormat.BINARY;
			for (var i:uint = 0; i<$data.length; i++) {
				var $type:String = $contentTypes[i].split("/")[1];
				if ($type=="jpeg")
					$type = "jpg";
				ml.addFile($data[i], "temp"+new Date().getTime()+"_"+i+"."+$type, "Filedata_"+i, $contentTypes[i]);
			}
			if ($postVariables) {
				for (var name:String in $postVariables) {
					ml.addVariable(name, $postVariables[name]);
				}
			}
			//ml.addVariable("fileCount",$data.length);

			ml.load($uri);
			ml.loader.addEventListener(Event.COMPLETE, initCompleteHandler(ml.loader, stringParser, $completeHandler));
			ml.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);

			return ml.loader;
		}

		private static function uploadBynaryImage($uri:String, $data:ByteArray, $completeHandler:Function = null, $contentType:String = "application/octet-stream", $postVariables:URLVariables = null):URLLoader
		{
			var $type:String = $contentType.split("/")[1];
			if ($type=="jpeg")
				$type = "jpg";
			var ml:MultipartURLLoader = new MultipartURLLoader();
			ml.dataFormat = URLLoaderDataFormat.BINARY;
			ml.addFile($data, "temp"+new Date().getTime()+"."+$type, "Filedata", $contentType);

			if ($postVariables) {
				for (var name:String in $postVariables) {
					ml.addVariable(name, $postVariables[name]);
				}
			}

			ml.load($uri);
			ml.loader.addEventListener(Event.COMPLETE, initCompleteHandler(ml.loader, stringParser, $completeHandler));
			ml.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);

			return ml.loader;
		}


		public static function uploadMultipleBynary($uri:String, $data:Vector.<ByteArray>, $contentTypes:Array, $type:Array, $completeHandler:Function = null, $postVariables:URLVariables = null):URLLoader
		{
			var ml:MultipartURLLoader = new MultipartURLLoader();
			ml.dataFormat = URLLoaderDataFormat.BINARY;
			for (var i:uint = 0; i<$data.length; i++) {
				ml.addFile($data[i], "temp"+new Date().getTime()+"_"+i+"."+$type[i], "Filedata_"+i, $contentTypes[i]);
			}
			if ($postVariables) {
				for (var name:String in $postVariables) {
					ml.addVariable(name, $postVariables[name]);
				}
			}
			//ml.addVariable("fileCount",$data.length);

			ml.load($uri);
			ml.loader.addEventListener(Event.COMPLETE, initCompleteHandler(ml.loader, stringParser, $completeHandler));
			ml.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);

			return ml.loader;
		}

		public static function uploadBynary($uri:String, $data:ByteArray, $completeHandler:Function = null, $type:String = "", $contentType:String = "application/octet-stream", $postVariables:URLVariables = null):URLLoader
		{
			var ml:MultipartURLLoader = new MultipartURLLoader();
			ml.dataFormat = URLLoaderDataFormat.BINARY;
			ml.addFile($data, "temp"+new Date().getTime()+"."+$type, "Filedata", $contentType);

			if ($postVariables) {
				for (var name:String in $postVariables) {
					ml.addVariable(name, $postVariables[name]);
				}
			}

			ml.load($uri);
			ml.loader.addEventListener(Event.COMPLETE, initCompleteHandler(ml.loader, stringParser, $completeHandler));
			ml.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);

			return ml.loader;
		}


		public static function killActivity($loader:*):void
		{
			if (completeActivities[$loader]&&completeActivities[$loader] is IEventDispatcher) {
				try {
					IEventDispatcher($loader).removeEventListener(Event.COMPLETE, completeActivities[$loader]);
					IEventDispatcher($loader).removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				} catch (e:Error) {
				}
				delete completeActivities[$loader];
			}
		}

		public static function loadString($uri:String, $completeHandler:Function, $variables:URLVariables = null, $method:String = URLRequestMethod.POST):URLLoader
		{
			var ur:URLRequest = composeURLRequest($uri, $variables, $method);
			var ul:URLLoader = new URLLoader();
			ul.addEventListener(Event.COMPLETE, initCompleteHandler(ul, stringParser, $completeHandler));
			ul.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			ul.load(ur);
			return ul;
		}

		public static function loadXML($uri:String, $completeHandler:Function, $variables:URLVariables = null, $method:String = URLRequestMethod.POST):URLLoader
		{
			var ur:URLRequest = composeURLRequest($uri, $variables, $method);
			var ul:URLLoader = new URLLoader();
			ul.addEventListener(Event.COMPLETE, initCompleteHandler(ul, xmlParser, $completeHandler));
			ul.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			ul.load(ur);
			return ul;
		}

		public static function loadJSON($uri:String, $completeHandler:Function, $variables:URLVariables = null, $method:String = URLRequestMethod.POST):URLLoader
		{
			var ur:URLRequest = composeURLRequest($uri, $variables, $method);
			var ul:URLLoader = new URLLoader();
			ul.addEventListener(Event.COMPLETE, initCompleteHandler(ul, jsonParser, $completeHandler));
			ul.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			ul.load(ur);
			return ul;
		}

		private static function stringParser(e:Event):String
		{
			try {
				return String(URLLoader(e.currentTarget).data);
			} catch (e:Error) {
			}
			return null;
		}

		private static function xmlParser(e:Event):XML
		{
			try {
				return XML(String(URLLoader(e.currentTarget).data));
			} catch (e:Error) {
			}
			return null;
		}

		private static function jsonParser(e:Event):Object
		{
			try {
				return AdobeJSON.decode(String(URLLoader(e.currentTarget).data));
			} catch (e:Error) {
			}
			return null;
		}

		private static function handleIOError(e:IOErrorEvent):void
		{
			trace(" FileActivity:: handleIOError : ", e.text);
		}

		private static function initCompleteHandler(loader:*, parser:Function = null, callBack:Function = null):Function
		{
			var fnc:Function = function(e:Event):void
			{

				if (callBack is Function) {
					if (callBack.length==1) {

						if (parser is Function) {
							callBack(parser(e));
						} else {
							callBack(e);
						}

					} else {
						callBack();
					}
				}
				killActivity(loader);
			}
			completeActivities[loader] = fnc;
			return fnc;
		}

		private static function composeURLRequest($uri:String, $variables:URLVariables = null, $method:String = URLRequestMethod.POST):URLRequest
		{
			var req:URLRequest = new URLRequest($uri);
			req.method = $method;
			if ($variables)
				req.data = $variables;
			return req;
		}

	}
}
