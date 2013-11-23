package net.area80.async
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import org.osflash.signals.Signal;

	public class AsyncTaskManager
	{
		public static const RUN:String = 'run';
		public static const STOP:String = 'stop';
		public static const PAUSE:String = 'pause';
		public static const VERBOSE:Boolean = true;

		public var signalComplete:Signal = new Signal();
		public var signalProgress:Signal = new Signal(Number, Number);
		public var signalEvent:Signal = new Signal(String);

		public var maxDelayTime:Number = 1; //2000;
		public var isRunning:Boolean = false;

		protected var timer:Timer;
		protected var timeDelay:Number = 0;
		protected var coolDownTimeMultiplier:Number = 0;

		protected var _currentTask:int = 0;

		protected var taskArray:Vector.<AsyncTask> = new Vector.<AsyncTask>();

		protected var timeBeforeTask:Number;

		public function AsyncTaskManager(coolDownTimeMultiplier:Number = 0)
		{
			this.coolDownTimeMultiplier = coolDownTimeMultiplier;
			timer = new Timer(timeDelay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, progressTask);
		}

		public function dispose():void
		{
			taskArray = new Vector.<AsyncTask>;
			signalComplete.removeAll();
			signalEvent.removeAll();
			signalProgress.removeAll();
		}

		/**
		 *
		 * @param taskWithAnAsyncTaskAsArgument this will return AsyncTask as an argument, use it to controll task timing.
		 * @param name
		 * @param autoRelease If this task need to wait until other event listener completes, autoRelease should be set to false. After complete you should call task.release() to be done. You can also use task.wait to prevent the next task to be run.
		 *
		 */
		public function addTask(taskWithAnAsyncTaskAsArgument:Function, name:String = "", autoRelease:Boolean = true):void
		{
			taskArray.push(new AsyncTask(this, name, taskWithAnAsyncTaskAsArgument, autoRelease));
		}

		/**
		 * run function can use as resume after pause function.
		 */
		public function run():void
		{
			if (taskArray.length!=0) {
				if (!isRunning) {
					isRunning = true;
					delay();
					signalEvent.dispatch(RUN);
				}
			} else {
				throw new Error("addTask First!!!");
			}
		}

		/**
		 * can call run() to resume task.
		 *
		 */
		public function pause():void
		{
			timer.stop();
			signalEvent.dispatch(PAUSE);
		}

		/**
		 * reset and stop all task.
		 *
		 */
		public function stop():void
		{
			_currentTask = 0;
			timer.stop();
			taskArray = new Vector.<AsyncTask>();
			signalEvent.dispatch(STOP);
			signalEvent.removeAll();
		}

		public function addBitmapDataLoaderAsTask(url:String, callbackWithBitmapData:Function, disposeBitmapDataAfterCallback:Boolean = true):void
		{
			this.addTask(function(task:AsyncTask):void {
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function onComplete(e:Event):void {
					callbackWithBitmapData(Bitmap(loader.content).bitmapData);
					if (disposeBitmapDataAfterCallback) {
						Bitmap(loader.content).bitmapData.dispose();
					}
					try {
						loader.unload();
					} catch (e:Error) {}
					try {
						loader.close();
					} catch (e:Error) {}
					try {
						loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
					} catch (e:Error) {}
					task.release();
				});
				loader.load(new URLRequest(url));
			}, "addBitmapAssetByURL "+url, false);
		}

		/**
		 *
		 * @param url from Application path
		 * @param callbackWithBitmapData
		 *
		 */
		public function addAtfDataLoaderAsTask(url:String, callbackWithAtfByteArray:Function):void
		{
			this.addTask(function(task:AsyncTask):void {
				var atfFile:File = File.applicationDirectory.resolvePath(url);
				var stream:FileStream = new FileStream();
				stream.addEventListener(Event.COMPLETE, readBytes);
				stream.openAsync(atfFile, FileMode.READ);
				function readBytes(e:Event):void {
					var atfBytes:ByteArray = new ByteArray();
					stream.readBytes(atfBytes);
					stream.removeEventListener(Event.COMPLETE, readBytes);
					stream.close();
					callbackWithAtfByteArray(atfBytes);
					task.release();
				}
			/*var bytes:ByteArray = new ByteArray();
			var ldr:URLLoader = new URLLoader();
			ldr.dataFormat = URLLoaderDataFormat.BINARY;
			var req:URLRequest = new URLRequest(url);
			ldr.addEventListener(Event.COMPLETE, completeHandler);
			ldr.load(req);
			function completeHandler(e:Event):void {
				callbackWithAtfByteArray(bytes);
			}*/

			}, "addAtfAssetByURL "+url, false);
		}

		public function get totalTask():Number
		{
			return taskArray.length;
		}

		public function get currentTask():int
		{
			return _currentTask;
		}

		protected function log(message:String):void
		{
			if (VERBOSE)
				trace("[AsyncTaskManager] "+message);
		}

		protected function progressTask(e:TimerEvent = null):void
		{
			timer.stop();
			timeBeforeTask = getTimer();

			//processing
			log("Task "+taskArray[_currentTask].name+" is about to run.");
			taskArray[_currentTask].run();



		}

		internal function next():void
		{
			//timestamp
			timeDelay = getTimer()-timeBeforeTask;
			log("Task "+taskArray[_currentTask].name+" is done after "+timeDelay+"ms.");

			_currentTask++;

			//next
			if (_currentTask>=taskArray.length) {
				complete();
			} else {
				delay();
				signalProgress.dispatch(_currentTask, taskArray.length);
			}
		}

		protected function complete():void
		{
			isRunning = false;
			_currentTask = 0;
			timer.stop();
			taskArray = new Vector.<AsyncTask>();
			signalComplete.dispatch();
		}

		protected function delay():void
		{
			timer.delay = Math.min(maxDelayTime, timeDelay*coolDownTimeMultiplier);
			timer.start();
		}

	}
}



