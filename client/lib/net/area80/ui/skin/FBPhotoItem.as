package net.area80.ui.skin
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.area80.display.loader.ImageBox;
	
	
	public class FBPhotoItem extends Sprite
	{
		public var selected_photo:Sprite;
		public var con_thum:Sprite;
		public var preload_mc:Sprite;
		public var bg_thum:MovieClip;
		public var ld:ImageBox;
		public var thumWidth:uint = 134;
		public var thumHeight:uint = 98;
		
		public function FBPhotoItem($path:String)
		{	
			
		}
		public function setLoadPhoto($path:String):void
		{
			ld = new ImageBox($path,thumWidth,thumHeight,true);
			ld.load();
			con_thum.addChild(ld);
		}
	}
}