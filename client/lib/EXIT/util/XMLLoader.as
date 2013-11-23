package EXIT.util
{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;


	public class XMLLoader
	{
		private var urlLoader:URLLoader
		private var urlRequest:URLRequest;
		private var onComplete:Function;
		private var onIOError:Function;


		/**
		 *
		 * @param onComplete(xml:XML):void{}
		 * @param onIOError(msg:String):void{}
		 *
		 */
		public function XMLLoader(onComplete:Function, onIOError:Function = null)
		{
			this.onComplete = onComplete;
			this.onIOError = onIOError;
		}

		public function load(_url:String, _data:*):void
		{
			trace("loadXML .. url:"+_url);
			unload();
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
			{
				trace(" ......... server down .........");
				if (onIOError!=null)onIOError(e.text);
			});
			urlRequest = new URLRequest(_url);
			urlRequest.data = _data;
			urlLoader.load(urlRequest);
		}

		public function unload():void
		{
			if (urlLoader) {
				urlLoader.close();
				urlLoader.removeEventListener(Event.COMPLETE, loaded);
				urlLoader = null;
			}
		}

		private function loaded(e:Event):void
		{
			trace('loaded');
			try {
				var xml:XML = new XML(e.target.data);
				onComplete(xml);
			} catch (err:Error) {
				trace(err.message);
				if (onIOError!=null)
					onIOError(err.message);
			}
		}
	}
}
