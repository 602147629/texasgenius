package net.pirsquare.m
{
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	import org.osflash.signals.Signal;

	public class MobileFileUtil
	{
		public static function deleteFileAsync(fileName:String = "undefined", eventHandler:Function = null):Signal
		{
			DebugUtil.trace(" * delete : " + fileName);

			const _eventHandler:Function = function(event:Event):void
			{
				if (event.type != Event.COMPLETE)
					return;

				DebugUtil.trace(" ^ deleted : " + event);

				// gc
				_file.removeEventListener(Event.COMPLETE, _eventHandler);

				if (eventHandler is Function)
					eventHandler(event);

				_completeSignal.dispatch();
			}

			var _file:File;

			try
			{
				_file = File.documentsDirectory.resolvePath(fileName);
			}
			catch (e:*)
			{
				trace(e);
			}

			if (!_file)
				return null;

			const _completeSignal:Signal = new Signal();

			_file.addEventListener(Event.COMPLETE, _eventHandler)
			_file.deleteFileAsync();

			return _completeSignal;
		}

		public static function getFile(fileName:String):File
		{
			return File.documentsDirectory.resolvePath(fileName);
		}

		public static function openByteArray(fileName:String = "undefined", eventHandler:Function = null):Signal
		{
			DebugUtil.trace(" * openByteArray : " + fileName);

			//const _file:File = File.documentsDirectory.resolvePath(fileName);
			// TODO : katopz
			const _file:File = File.applicationDirectory.resolvePath(fileName);
			const fs:FileStream = new FileStream();
			const _completeSignal:Signal = new Signal(ByteArray);
			const ba:ByteArray = new ByteArray;

			const _eventHandler:Function = function(event:Event):void
			{
				DebugUtil.trace(" ^ read : " + fs.bytesAvailable);

				if (event.type == ProgressEvent.PROGRESS)
				{
					if (eventHandler is Function)
						eventHandler(event);
				}
				else if (event.type == Event.COMPLETE)
				{
					const ba:ByteArray = new ByteArray;
					fs.readBytes(ba, fs.position, fs.bytesAvailable);

					fs.close();
					// gc
					fs.removeEventListener(IOErrorEvent.IO_ERROR, _eventHandler);
					fs.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, _eventHandler);
					fs.removeEventListener(Event.COMPLETE, _eventHandler);

					if (eventHandler is Function)
						eventHandler(event, ba);

					_completeSignal.dispatch(ba);
				}
			}

			// handle event
			fs.addEventListener(IOErrorEvent.IO_ERROR, _eventHandler);
			fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, _eventHandler);
			fs.addEventListener(Event.COMPLETE, _eventHandler);

			// open for read
			fs.openAsync(_file, FileMode.READ);

			return _completeSignal;
		}

		public static function open(fileName:String = "undefined", eventHandler:Function = null):Signal
		{
			DebugUtil.trace(" * open : " + fileName);

			return openByteArray(fileName, function(event:Event, ba:ByteArray = null):void
			{
				if (event.type != Event.COMPLETE)
					return;

				LoaderUtil.loadBytes(ba, function(event:Event):void
				{
					if (event.type != Event.COMPLETE)
						return;

					// gc
					ba.clear();
					ba = null;

					if (eventHandler is Function)
						eventHandler(event);
				});
			});
		}

		public static function save(data:*, fileName:String = "undefined", eventHandler:Function = null):Signal
		{
			DebugUtil.trace(" * save : " + fileName);

			const _file:File = File.documentsDirectory.resolvePath(fileName);
			const fs:FileStream = new FileStream();
			const _completeSignal:Signal = new Signal;

			const _eventHandler:Function = function(event:Event):void
			{
				DebugUtil.trace(" ^ save : " + event);

				if (eventHandler is Function)
					eventHandler(event);

				// workaround bug, complete never fire
				if ((event is OutputProgressEvent) && (OutputProgressEvent(event).bytesPending == 0))
				{
					DebugUtil.trace(" ! saved : " + event);

					fs.close();

					// gc
					fs.removeEventListener(IOErrorEvent.IO_ERROR, _eventHandler);
					fs.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, _eventHandler);

					if (eventHandler is Function)
						eventHandler(new Event(Event.COMPLETE));

					_completeSignal.dispatch();
				}
				else if (event is IOErrorEvent)
				{
					fs.close();
				}
			}

			// handle event
			fs.addEventListener(IOErrorEvent.IO_ERROR, _eventHandler);
			fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, _eventHandler);

			// open for write
			fs.openAsync(_file, FileMode.WRITE);

			if (data is String)
			{
				fs.writeUTFBytes(data);
			}
			else
			{
				const byteArray:ByteArray = data as ByteArray;
				fs.writeBytes(byteArray, 0, byteArray.length);
			}

			return _completeSignal;
		}
	}
}
