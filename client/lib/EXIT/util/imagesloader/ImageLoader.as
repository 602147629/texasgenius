package EXIT.util.imagesloader
{

	import flash.display.Bitmap;
	
	import org.osflash.signals.Signal;

	public class ImageLoader
	{
		public var signalCompleteAll:Signal = new Signal();
		private var queuePath:Vector.<ImageLoaderInfo> = new Vector.<ImageLoaderInfo>();
		public function ImageLoader()
		{
		}

		/////////////////////// PUBLIC FUNCTION ////////////////////////////
		public function loadByUrl(_url:String, _callback:Function , args:Array=null):void
		{
			var imageLoaderInfo:ImageLoaderInfo = new ImageLoaderInfo(_url, _callback, loaded , args);
			queuePath.push(imageLoaderInfo);
		}

		public function unload():void
		{
			//	trace("Image loader fuji unload - >");
			for (var i:uint; i <= queuePath.length - 1; i++) {
				queuePath[i].unload();
			}
			queuePath = new Vector.<ImageLoaderInfo>();
		}

		//////////////////////////PRIVATE FUNCTION //////////////////////////

		protected function loaded(_loaderInfo:ImageLoaderInfo, bitmap:Bitmap):void
		{

			var index:int = queuePath.indexOf(_loaderInfo);
			queuePath.splice(index, 1);
			if( queuePath.length <=0 ){
				signalCompleteAll.dispatch();
			}
		}
	}
}
