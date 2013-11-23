// Example
/*var skinAsset:FBPhotoBrowserSkinAsset = new FBPhotoBrowserSkinAsset();
skinAsset.thumSpacing = 5;
photobrowser = new FBPhotoBrowser(skinAsset,access_token,3);

last update
21/10/2011
*/


package net.area80.ui.component
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.utils.Dictionary;

	import net.area80.facebook.FacebookConnectData;
	import net.area80.ui.skin.FBAlbumItem;
	import net.area80.ui.skin.FBPhotoBrowserSkin;
	import net.area80.ui.skin.FBPhotoItem;

	import org.osflash.signals.Signal;

	public class FBPhotoBrowser extends Sprite
	{
		public var proxyURL:String = "/serverside/proxy.php?url=";
		private var _access_token:String;
		private var _facebookconnect:FacebookConnectData;
		private var _skin:FBPhotoBrowserSkin;
		private var _albumGrid:UIDataGrid;
		private var _photoGrid:UIDataGrid;

		private var _photoData:Array;
		private var _currentAlbum:FBAlbumItem;
		private var _currentAlbumContainer:Sprite;
		private var _currentAlbumBitmap:BitmapData;
		private var _maxPhotoData:uint;
		private var _spacing:uint;

		//return data
		public var SIGNAL_ERROR:Signal;
		public var SIGNAL_ALBUM_LOADED:Signal;
		public var SIGNAL_SELECTED_ITEM:Signal;
		public var SIGNAL_CANCEL_ITEM:Signal;
		public var SIGNAL_ERROR_MAX_ITEM:Signal;

		public var CURRENT_ALBUMID:String;

		private var itemAlbumIdDic:Dictionary;
		private var urlDic:Dictionary;
		private var CURRENT_URL:String;
		private var maxSelect:uint;
		private var max:uint = 0;
		private var image:String;
		private var _globalmaxAlbum:uint = 0;
		private var canSelected:Boolean = true;
		private var username:String;

		public function FBPhotoBrowser($skin:FBPhotoBrowserSkin, $token:String, $maxSelect:uint = 1)
		{
			Security.allowInsecureDomain("*");
			Security.allowDomain('*');
			Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");

			CURRENT_URL = new String();
			SIGNAL_ERROR_MAX_ITEM = new Signal(Object);
			SIGNAL_CANCEL_ITEM = new Signal();
			SIGNAL_ERROR = new Signal(Object);
			SIGNAL_ALBUM_LOADED = new Signal(Object);
			SIGNAL_SELECTED_ITEM = new Signal(Array);
			_access_token = $token;
			_skin = $skin;
			maxSelect = $maxSelect;
			addChild(_skin);
			if (!stage) {
				addEventListener(Event.ADDED_TO_STAGE, init);
			} else {
				init();
			}
			//create UIDataGrid

		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			urlDic = new Dictionary();
			itemAlbumIdDic = new Dictionary();

			_spacing = _skin.thumSpacing;
			_albumGrid = new UIDataGrid(1, _spacing, true);
			addChild(_albumGrid);
			_photoGrid = new UIDataGrid(3, _spacing, true);
			addChild(_photoGrid);
			_currentAlbum = new FBAlbumItem();
			_currentAlbumContainer = new Sprite();
			_skin.currentAlbumContainer.addChild(_currentAlbumContainer);
			_facebookconnect = new FacebookConnectData(_access_token);
			_facebookconnect.loadFacebookUser(_access_token);
			_facebookconnect.SIGNAL_USERS_COMPLETE.add(onLoadedUser);
			//_facebookconnect.loadFacebookAlbums();
			_facebookconnect.SIGNAL_ALBUMS_COMPLETE.add(onLoadedAlbum);
			addChild(_facebookconnect);

			//_skin.btn_cancel.visible = false;
			_skin.btn_upload.visible = false;
			_skin.btn_upload.addEventListener(MouseEvent.CLICK, onUpload);
			_skin.btn_cancel.addEventListener(MouseEvent.CLICK, onCancel);
			_photoData = new Array();
		}

		private function onLoadedUser(obj:*):void
		{
			_skin.btn_cancel.visible = true;
			_skin.name_txt.text = username = String(obj.name);

			//trace(username);
		}

		private function onLoadedCover(coverData:Object):void
		{

		}

		private function onLoadedAlbum(obj:*):void
		{
			if (obj) {
				var albumData:Array = obj.data as Array;
				if (albumData.length>0) {
					createAlbums(albumData.length, albumData);
					SIGNAL_ALBUM_LOADED.dispatch(obj);
				}
			} else {
				SIGNAL_ERROR.dispatch(obj);
			}
		}

		public function createAlbums(maxAlbum:uint, obj:*):void
		{
			_facebookconnect.loadFacebookPhotos(obj[0].id);
			_facebookconnect.SIGNAL_PHOTOS_COMPLETE.add(onLoadedPhotos);
			for (var i:uint = 0; i<maxAlbum; i++) {
				var path:String = "https://graph.facebook.com/"+obj[i].id+"/picture?access_token="+_access_token+"&type=album"
				var createTime:String = obj[i].created_time;
				createTime = createTime.substr(0, 10);
				var itemAlbum:FBAlbumItem = (_skin.getAlbumItem(obj[i].name, createTime, path));
				itemAlbum.thumWidth = 150;
				itemAlbum.thumHeight = 110;
				//itemAlbum.num_txt.visible = false;
				if (obj[i].count) {
					itemAlbum.num_txt.text = obj[i].count+" photos";
				}
				itemAlbum.num_bg.visible = false;
				itemAlbum.setLoadAlbum(path);
				itemAlbum.SIGNAL_COMPLETE.add(onLoadedAlbumThum);
				var albumData:Object = new Object();
				albumData.id = obj[i].id;
				albumData.currentAlbum = itemAlbum;
				urlDic[itemAlbum] = path;
				itemAlbumIdDic[itemAlbum] = obj[i].id;
				itemAlbum.name_txt.htmlText = obj[i].name;
				itemAlbum.create_txt.visible = false;
				itemAlbum.create_txt.htmlText = createTime;
				itemAlbum.buttonMode = true;
				itemAlbum.addEventListener(MouseEvent.CLICK, onItemAlbumClick);
				if (i==0) {
					_currentAlbum = itemAlbum;
					CURRENT_URL = path;
					setCurrentAlbum();
				}
				_albumGrid.addItem(itemAlbum, albumData);
			}
			_skin.albumContainer.addChild(_albumGrid);
			_albumGrid.update();
			_skin.albumScrollbar.updateStatus();
			//_skin.albumScrollbar.x = _skin.albumContainer.x+_skin.albumContainer.width+10;
			_skin.albumScrollbar.x = 188;
			_skin.albumScrollbar.y = _skin.albumContainer.y+5;
		}

		private function onLoadedAlbumThum(_item:FBAlbumItem):void
		{
			_item.preload_mc.visible = false;
		}

		private function onItemAlbumClick(e:MouseEvent):void
		{
			if (e) {


				CURRENT_ALBUMID = itemAlbumIdDic[e.currentTarget];
				_currentAlbum = FBAlbumItem(e.currentTarget);
				CURRENT_URL = urlDic[_currentAlbum];
				setCurrentAlbum();
				_facebookconnect.loadFacebookPhotos(CURRENT_ALBUMID);
				_facebookconnect.SIGNAL_PHOTOS_COMPLETE.add(onLoadedPhotos);
			}
		}

		private function onLoadedPhotos(obj:*):void
		{
			if (obj) {
				var photoData:Array = obj.data as Array;
				_globalmaxAlbum = photoData.length;
				createPhotoAlbums(photoData);

			}
		}

		public function createPhotoAlbums(obj:*):void
		{
			_photoGrid.removeItem();
			for (var i:uint = 0; i<_globalmaxAlbum; i++) {
				var itemPhoto:FBPhotoItem = (_skin.getPhotoItem(obj[i].source));
				itemPhoto.bg_thum.stop();
				var photoData:Object = new Object();
				photoData.id = obj[i].id;
				photoData.max = obj[i].count;
				photoData.image = obj[i].source;
				photoData.itemPhoto = itemPhoto;

				setSelected(photoData, itemPhoto);
				itemPhoto.setLoadPhoto(photoData.image);
				itemPhoto.ld.addEventListener(Event.COMPLETE, onLoadedPhotoItem);
				itemPhoto.addEventListener(MouseEvent.MOUSE_OVER, onItemOver);
				itemPhoto.addEventListener(MouseEvent.MOUSE_OUT, onItemOut);
				_photoGrid.addItem(itemPhoto, photoData);
				_skin.photoContainer.addChild(_photoGrid);
			}
			_photoGrid.SIGNAL_ITEM_CLICK.add(onItemPhotoClick);
			_photoGrid.update();
			_skin.photoScrollbar.updateStatus();
			_skin.photoScrollbar.x = _skin.photoContainer.x+_skin.photoContainer.width+15;
			_skin.photoScrollbar.y = _skin.photoContainer.y-8;


		}

		private function onItemOver(e:MouseEvent):void
		{
			e.currentTarget.bg_thum.gotoAndStop(2);
		}

		private function onItemOut(e:MouseEvent):void
		{
			e.currentTarget.bg_thum.gotoAndStop(1);
		}

		private function onLoadedPhotoItem(e:Event):void
		{
			var itemAlbum:FBPhotoItem = e.currentTarget.parent.parent as FBPhotoItem;
			itemAlbum.preload_mc.visible = false;
			max++;
			if (max>=_globalmaxAlbum) {
				max = 0;
			}
			//setCurrentAlbum();
		}

		private function onItemPhotoClick(data:*):void
		{

			_maxPhotoData = _photoData.length;
			var itemPhoto:FBPhotoItem = FBPhotoItem(data.itemPhoto);
			if (itemPhoto.selected_photo.visible==true) {
				canSelected = true;
			}

			if (canSelected) {

				if (itemPhoto.selected_photo.visible==true) {
					itemPhoto.selected_photo.visible = false;
				} else {
					itemPhoto.selected_photo.visible = true;
				}
				_currentAlbum.num_txt.visible = true;
				_currentAlbum.num_bg.visible = true;
				var num:uint = uint(_currentAlbum.num_txt.text);

				if (_maxPhotoData<1) {
					num++;
					_photoData.push(data.image);
				} else {
					for (var d:uint = 0; d<_maxPhotoData; d++) {
						if (data.image!=_photoData[d]) {
							if (d==(_maxPhotoData-1)) {
								num++;
								_photoData.push(data.image);
							}
						}
					}
					for (var i:uint = 0; i<_maxPhotoData; i++) {
						if (data.image==_photoData[i]) {
							num--;
							_photoData.splice(_photoData.indexOf(data.image), 1);
						}

					}

				}
				if (num<=0) {
					_currentAlbum.num_txt.visible = false;
					_currentAlbum.num_bg.visible = false;
				} else {
					_currentAlbum.num_txt.visible = true;
					_currentAlbum.num_bg.visible = true;
				}
				_maxPhotoData = _photoData.length;
				_currentAlbum.num_txt.text = String(num);
				SIGNAL_SELECTED_ITEM.dispatch(_photoData);
				setCurrentAlbum();
			} else {
				SIGNAL_ERROR_MAX_ITEM.dispatch(data);
				_maxPhotoData = _photoData.length;
			}


			if (_maxPhotoData>=maxSelect&&maxSelect!=0) {
				canSelected = false;
			} else {
				canSelected = true;
			}
		}

		private function setCurrentAlbum():void
		{
			while (_currentAlbumContainer.numChildren>0) {
				_currentAlbumContainer.removeChildAt(0);
			}
			var albumitem:FBAlbumItem = (_skin.getAlbumItem(_currentAlbum.name_txt.text, _currentAlbum.create_txt.text, CURRENT_URL));
			albumitem.num_txt.text = _currentAlbum.num_txt.text;
			albumitem.name_txt.text = _currentAlbum.name_txt.text;
			albumitem.create_txt.text = _currentAlbum.create_txt.text;
			albumitem.create_txt.visible = false;
			_skin.by_txt.text = "by";
			_skin.album_txt.text = albumitem.name_txt.text;
			if (username) {
				_skin.name_txt.text = username;
			}
			albumitem.setLoadAlbum(CURRENT_URL);
			_currentAlbumContainer.addChild(albumitem);
		}

		private function setSelected(photoData:Object, itemPhoto:FBPhotoItem):void
		{
			itemPhoto.selected_photo.visible = false;
			for (var i:uint = 0; i<_maxPhotoData; i++) {
				if (photoData.image==_photoData[i]) {
					itemPhoto.selected_photo.visible = true;
				}
			}

		}

		private function onUpload(e:MouseEvent = null):void
		{
			_skin.btn_upload.visible = true;
			SIGNAL_SELECTED_ITEM.dispatch(_photoData);
		}

		private function onCancel(e:MouseEvent):void
		{
			SIGNAL_CANCEL_ITEM.dispatch();
		}

		private function dispose(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
}
