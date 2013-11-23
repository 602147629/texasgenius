package net.area80.ui.skin
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import net.area80.ui.component.Scrollbar;
	import net.area80.utils.DrawingUtils;
	
	//import view.ui.component.Scrollbar;
	
	public class FBPhotoBrowserSkin extends Sprite
	{
		public var by_txt:TextField;
		public var name_txt:TextField;
		public var album_txt:TextField;
		public var thumSpacing:uint;
		public var albumContainer:Sprite;
		public var photoContainer:Sprite;
		public var currentAlbumContainer:Sprite; 
		public var albumScrollbar:Scrollbar;
		public var photoScrollbar:Scrollbar;
		public var main_bg:Sprite;
		//public var con:Sprite;
		//public var con_mask:Sprite;
		public var dummyPhoto:Sprite;
		public var dummyAlbum:Sprite;
		public var btn_upload:SimpleButton;
		public var btn_cancel:SimpleButton;
		//public var bg:MovieClip;
		//public var photo_mask:Sprite;
		//public var album_mask:Sprite;
		public function FBPhotoBrowserSkin()
		{
			//bg.visible = false;
			//photo_mask = DrawingUtils.getRectSprite(600,475);
			//album_mask = DrawingUtils.getRectSprite(160,315);
			//addChild(photo_mask);
			//addChild(album_mask);
		}
		public function getAlbumItem(_name:String,_date:String,_path:String):FBAlbumItem
		{
			return null;
		}
		public function getPhotoItem($path:String):FBPhotoItem
		{
			return null;
		}
	}
}