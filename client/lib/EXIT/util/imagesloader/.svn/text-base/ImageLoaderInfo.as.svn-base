package EXIT.util.imagesloader
{

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	internal final class ImageLoaderInfo
	{
		public var path:String;
		public var typeImage:String;
		public var id:String
		public var callback:Function;

		private var _loaded:Function;
		private var args:Array;

		private var loader:Loader;

		public function ImageLoaderInfo(_path:String, _callback:Function, _loaded:Function , _args:Array)
		{
			path = _path;
			callback = _callback;
			this._loaded = _loaded;
			args = _args;

			loader = new Loader();
			//trace("load->" + path);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			loader.load(new URLRequest(path));
		}

		private function loaded(event:Event):void
		{
			var bitmap:Bitmap = new Bitmap(Bitmap(event.currentTarget.content).bitmapData.clone());
			if (typeof(callback) == "function"){
				if( args ){
					callback(bitmap,args);
				}else{
					callback(bitmap);
				}
			}
			_loaded(this, bitmap);

			unload();
		}

		private function loadError(event:Event):void
		{
			trace('    - > cannot find image :::' + path);
			if (typeof(callback) == "function"){
				if( args ){
					callback(null,args);
				}else{
					callback(null);
				}
			}
			_loaded(this, null);
			unload();
		}

		public function unload():void
		{
			callback = null;

			if (loader && loader.content) {
				//	trace("Image loader2 unload - >" + loader.content + " @" + path);
				if (loader.content is Bitmap) {
					Bitmap(loader.content).bitmapData.dispose();
				}
			}
			try {

				loader.unload();
			} catch (e:Error) {
			}
			try {
				loader.close();
			} catch (e:Error) {
			}
			loader = null;
		}
	}
}
