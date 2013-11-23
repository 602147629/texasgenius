package net.area80.ui.skin
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.*;
	import flash.text.TextField;
	
	import org.osflash.signals.Signal;
	
	public class FBAlbumItem extends Sprite
	{
		public var name_txt:TextField;
		public var create_txt:TextField;
		public var num_txt:TextField;
		public var num_bg:Sprite;
		public var con_thum:Sprite;
		public var preload_mc:Sprite;
		public var bg_thum:Sprite;
		public var ldr:Loader;
		public var thumWidth:uint = 142;
		public var thumHeight:uint = 87;
		public var SIGNAL_COMPLETE:Signal;
		
		protected var content:Bitmap;
		protected var w:uint = 150;
		protected var h:uint = 110;
		private var separateDefinitions:LoaderContext;
		private var _path:String;
		public function FBAlbumItem()
		{	
			SIGNAL_COMPLETE = new Signal(FBAlbumItem);
			/*Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
			Security.loadPolicyFile("http://api.facebook.com/crossdomain.xml");*/
		}
		public function setLoadAlbum($path:String):void
		{
			this._path = $path;
			var childDefinitions:LoaderContext = new LoaderContext();
			childDefinitions.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			
			
			var addedDefinitions:LoaderContext = new LoaderContext();
			addedDefinitions.applicationDomain = ApplicationDomain.currentDomain;
			
			
			separateDefinitions = new LoaderContext();
			separateDefinitions.checkPolicyFile = true;
			separateDefinitions.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderLoadErrorHandler);
			ldr.load(new URLRequest($path),separateDefinitions);
			
			
			//ld = new ImageBox($path,thumWidth,thumHeight,true);
			//ld.load();
			con_thum.addChild(ldr);
		}
		private function onLoaderLoadErrorHandler(e:IOErrorEvent):void
		{
			ldr.load(new URLRequest(_path),separateDefinitions);
		}
		private function onLoadCompleteHandler (e:Event):void {
			preload_mc.visible = false;
			/*ldr.x = (this.width/2)-(ldr.width/2);
			ldr.y = (this.height/2)-(ldr.height/2);*/
			//w = ldr.width;
			//h = ldr.height;
			composeContent();
			SIGNAL_COMPLETE.dispatch(this);
		}
		private function composeContent ():void {
			var _scale:Number = 1;
			
			if(w!=0 || h!=0) {
				if(w == 0 && h!=0) {
					//height priority
					_scale = h/ldr.height;
				} else if (h == 0 && w != 0) {
					//width priority
					_scale = w/ldr.width;
				} else {
					//height & width priority
					_scale = Math.max(w/ldr.width,h/ldr.height);
				}
			}
			
			ldr.scaleX = ldr.scaleY = _scale;
		}
		
	}
}