package com.sleepydesign.net
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.IExternalizable;

	/**
	 * @example
	 *
	 * 	Browse image and add to container	: FileUtil.openImageTo(this);
	 * 	Browse image and trace				: FileUtil.openImage(trace);
	 * 	Browse jpg and listen				: FileUtil.open(["*.jpg"], eventHandler);
	 *
	 * @author	katopz
	 */
	public class FileUtil
	{
		/**
		 * Limit your upload size
		 */
		public static var UPLOAD_LIMIT:Number = 200000;

		/**
		 * prevent gc
		 */
		private static var _file:FileReference;

		/**
		 * Your upload path
		 */
		public static var UPLOAD_URL:String;

		private static var _this:FileUtil = new FileUtil;

		/**
		 * Browse with any file type and listen
		 * @param eventHandler
		 * @return FileReference
		 */
		public static function open(fileTypes:Array = null, eventHandler:Function = null):FileReference
		{
			fileTypes = fileTypes ? fileTypes : ["*.*"];
			eventHandler = (eventHandler is Function) ? eventHandler : trace;

			_file = new FileReference();

			function _eventHandler(event:Event):void
			{
				if (event.type == Event.SELECT)
				{
					_file.removeEventListener(Event.CANCEL, _eventHandler);
					_file.removeEventListener(Event.SELECT, _eventHandler);

					_file.addEventListener(Event.COMPLETE, _eventHandler);
					_file.load();
				}
				else if (event.type == Event.COMPLETE)
				{
					_file.removeEventListener(Event.COMPLETE, _eventHandler);
				}

				if (eventHandler is Function)
					eventHandler(event);
			}

			// add
			_file.addEventListener(Event.CANCEL, _eventHandler);
			_file.addEventListener(Event.SELECT, _eventHandler);

			_file.browse([new FileFilter(fileTypes.join(",").toString(), fileTypes.join(";").toString())]);

			return _file;
		}

		public static function openCompress(eventHandler:Function, type:String = URLLoaderDataFormat.TEXT):FileUtil
		{
			open(["*.bin"], function(event:Event):void
			{
				if (event.type == Event.COMPLETE || event.type == DataEvent.UPLOAD_COMPLETE_DATA)
				{
					var _byte:ByteArray = event.target["data"] as ByteArray;
					_byte.uncompress();

					if (type == URLLoaderDataFormat.TEXT)
					{
						// read as text
						eventHandler(new DataEvent(Event.COMPLETE, false, false, _byte.readUTFBytes(_byte.length)));
					}
					else
					{
						eventHandler(new ResultEvent(Event.COMPLETE, false, false, _byte));
					}
				}
				else
				{
					// other event
					trace(" ^ event : " + event);
					eventHandler(event);
				}
			});

			return _this;
		}

		public static var currentOpenByteArray:ByteArray;

		/**
		 * Browse image and listen
		 * @param eventHandler
		 * @return FileReference
		 */
		public static function openImage(eventHandler:Function, fileTypes:Array = null):FileReference
		{
			return open(fileTypes || ["*.jpg", "*.jpeg", "*.gif", "*.png"], function(event:Event):void
			{
				if (event.type == Event.COMPLETE)
				{
					LoaderUtil.loadBytes(event.target["data"], eventHandler);
				}
				else
				{
					// other event
					trace(" ^ event : " + event);
					eventHandler(event);
				}
			});
		}

		/**
		 * Browse image and add to container
		 * @param container
		 * @return FileReference
		 */
		public static function openImageTo(container:DisplayObjectContainer, fileTypes:Array = null):FileReference
		{
			return openImage(function onGetImage(event:Event):void
			{
				if (event.type == Event.COMPLETE)
					container.addChild(event.target["content"] as Bitmap);
			}, fileTypes);
		}

		public static function openXML(eventHandler:Function):FileReference
		{
			return open(["*.xml", "*.dae"], function(event:Event):void
			{
				if (event.type == Event.COMPLETE || event.type == DataEvent.UPLOAD_COMPLETE_DATA)
				{
					// complete event
					try
					{
						//FP10 just get data
						var _byte:ByteArray = event.target["data"] as ByteArray;
						eventHandler(new DataEvent(Event.COMPLETE, false, false, _byte.readUTFBytes(_byte.length)));
					}
					catch (e:*)
					{
						//FP9 need to reload ;p
						if (event.type == DataEvent.UPLOAD_COMPLETE_DATA)
							LoaderUtil.loadAsset(event["data"], eventHandler);
					}
				}
				else
				{
					// other event
					trace(" ^ event : " + event);
					eventHandler(event);
				}
			});
		}

		/**
		 * Save image to LOCAL
		 * @param eventHandler
		 * @return FileReference
		 */
		public static function save(data:*, defaultFileName:String = "undefined", onComplete:Function = null):FileReference
		{
			const fileReference:FileReference = new FileReference();

			function _eventHandler(event:Event):void
			{
				fileReference.removeEventListener(Event.COMPLETE, _eventHandler);
				fileReference.removeEventListener(Event.CANCEL, _eventHandler);

				if (onComplete is Function)
					onComplete(event);
			}

			fileReference.addEventListener(Event.COMPLETE, _eventHandler);
			fileReference.addEventListener(Event.CANCEL, _eventHandler);

			if (data is String)
			{
				fileReference.save(data, defaultFileName);
			}
			else
			{
				var rawBytes:ByteArray = new ByteArray();

				if (data is IExternalizable)
					IExternalizable(data).writeExternal(rawBytes);
				else if (data is ByteArray)
					rawBytes = data;

				fileReference.save(rawBytes, defaultFileName);
			}

			return fileReference;
		}

		public static function saveCompress(data:*, defaultFileName:String = "undefined", type:String = URLLoaderDataFormat.TEXT, onComplete:Function = null):void
		{
			const rawBytes:ByteArray = new ByteArray();

			if (type == URLLoaderDataFormat.TEXT)
			{
				// write as text
				if (!(data is String))
					throw new Error("Data type must be String");

				rawBytes.writeUTFBytes(data);
			}
			else
			{
				// write as binary
				if (!(data is ByteArray))
					throw new Error("Data type must be ByteArray");

				ByteArray(data).position = 0;

				rawBytes.writeBytes(data, 0, ByteArray(data).length);
			}

			rawBytes.compress();

			save(rawBytes, defaultFileName, onComplete);
		}
	}
}
import flash.events.Event;
import flash.utils.ByteArray;

internal class ResultEvent extends Event
{
	public var data:ByteArray;

	public function ResultEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:ByteArray = null)
	{
		super(type, bubbles, cancelable);

		this.data = data;
	}
}
