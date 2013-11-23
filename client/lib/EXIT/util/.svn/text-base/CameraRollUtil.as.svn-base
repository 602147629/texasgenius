package EXIT.util
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	public class CameraRollUtil
	{
		private static var _instance:CameraRollUtil;
		private var mediaSource:CameraRoll = new CameraRoll();
		private var imageLoader:Loader;
		private var onComplete:Function;
		private var onCancel:Function;
		private var onError:Function;

//		private static var debug:FlashText;

		// browse
		private var fileRef:FileReference;


		public function CameraRollUtil()
		{
			if (_instance) {
				throw new Error("Use getInstance instead!!!");
			}
		}

		public static function getInstance():CameraRollUtil
		{
//			debug = new FlashText("test",null,new TextFormat(ImageHTMLText.TAHOMA_FONT,20));
//			_stage.addChild(debug);
			if (!_instance) {
				_instance = new CameraRollUtil();
			}
			return _instance;
		}

		public function browse(_onComplete:Function, _onCancel:Function = null, _onError:Function = null):void
		{
			onComplete = _onComplete;
			onCancel = _onCancel;
			onError = _onError;
			/*debug.text = "CameraRoll.supportsBrowseForImage:"+CameraRoll.supportsBrowseForImage+"\n";
			debug.width = 640;
			debug.wordWrap = true;*/
			if (CameraRoll.supportsBrowseForImage) {
				mediaSource.addEventListener(MediaEvent.SELECT, imageSelected);
				mediaSource.addEventListener(Event.CANCEL, browseCanceled);

				mediaSource.browseForImage();
			} else {
				fileRef = new FileReference();
				fileRef.browse([new FileFilter("Images", "*.jpg;*.gif;*.png")]);
				fileRef.addEventListener(Event.SELECT, onFileSelected);
				fileRef.addEventListener(Event.COMPLETE, onFileLoaded);
//				if( onError!=null ) onError();
			}
		}


		private function imageSelected(event:MediaEvent):void
		{
			var imagePromise:MediaPromise = event.data;

			imageLoader = new Loader();
//			debug.text += "imagePromise.isAsync:"+imagePromise.isAsync+"\n";
			if (imagePromise.isAsync) {
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
				imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
				imageLoader.loadFilePromise(imagePromise);
			} else {
				imageLoader.loadFilePromise(imagePromise);
			}
		}

		private function browseCanceled(event:Event):void
		{
//			debug.text += "browseCanceled\n";
			if (onCancel!=null)
				onCancel();
		}

		private function imageLoaded(event:Event):void
		{
//			debug.text += "imageLoaded\n";
			onComplete(event.target.content);
		}

		private function imageLoadFailed(event:Event):void
		{
//			debug.text += "imageFail\n";
			onError();
		}


		///////////// BROWSE FOR TEST ?///////
		private function onFileSelected(e:Event):void
		{
			fileRef.load();
		}

		private function onFileLoaded(e:Event):void
		{
			var loader:Loader = new Loader();
			loader.loadBytes(e.target.data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
		}
	}
}
