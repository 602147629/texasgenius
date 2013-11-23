/* Example for this class

embed class 
var fbFListSkin:FBFriendListAsset = new FBFriendListAsset();

add parameter skin/row/colume/space/token and uid list on vector format
var fbFList:FBFriendList = new FBFriendList(fbFListSkin, 4, 4, 2,StaticModelPage.access_token,vo.frindList); 

add SIGNAL for upload / cancel / loaded & error


last update
21/10/2011

*/

package net.area80.ui.component
{
	import com.adobe.serialization.adobejson.AdobeJSON;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.utils.setTimeout;
	
	import net.area80.ui.component.DataGridPageSlider;
	import net.area80.ui.component.TextInput;
	import net.area80.ui.skin.FBFriendListItemSkin;
	import net.area80.ui.skin.FBFriendListSkin;
	import net.area80.utils.StringUtils;
	
	import org.osflash.signals.Signal;
	

	public class FBFriendList extends Sprite
	{
		/* recieve var */
		private var pageSlider:DataGridPageSlider;
		private var skin:FBFriendListSkin;
		private var row:uint;
		private var column:uint;
		private var spacing:Number;
		private var _token:String;
		private var _avatar_img:String;
		private var _username:String;
		/* object */
		private var allItemVectorFriend:Vector.<FBFriendListItemSkin>;
		private var selectedItemVectorFriend:Vector.<FBFriendListItemSkin>;
		private var searchItemVectorFriend:Vector.<FBFriendListItemSkin>;
		private var dataVectorFriendAll:Vector.<Object>;
		public var currentItem:FBFriendListItemSkin;
		/* mode */
		
		public static const ALL:String = "all";
		public static const SELETED:String = "seleted";
		public static const SEARCH:String = "search";
		private var mode:String = ALL;
		/* public var */
		public var SIGNAL_ERROR:Signal;
		public var SIGNAL_UPLOAD:Signal = new Signal(Vector.<String>);
		public var SIGNAL_CANCEL:Signal = new Signal();
		public var SIGNAL_IMAGE_LOADED:Signal = new Signal();
		private var friendUid:Vector.<String>;
		
		public function FBFriendList(skin:FBFriendListSkin, row:uint, column:uint, spacing:Number,token:String,$friendUid:Vector.<String>=null)
		{
			
			
			this.friendUid = $friendUid;	
			this._token = token;
			this.skin = skin;
			this.row = row;
			this.column = column;
			this.spacing = spacing;

			//skin.selectedBtn.visible = false;
			//skin.allBtn.visible = false;
			
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			skin.selectedBtn.bg.stop();
			skin.allBtn.bg.stop();
			skin.allBtn.bg.gotoAndStop(2);
			SIGNAL_ERROR = new Signal();
			dataVectorFriendAll = new Vector.<Object>;
			allItemVectorFriend = new Vector.<FBFriendListItemSkin>;
			selectedItemVectorFriend = new Vector.<FBFriendListItemSkin>;
			searchItemVectorFriend = new Vector.<FBFriendListItemSkin>;
			/* manage page slider */
			pageSlider = new DataGridPageSlider(row,column,spacing,skin.maskMc.width);
			pageSlider.x = skin.maskMc.x;
			pageSlider.y = skin.maskMc.y;
			pageSlider.mask = skin.maskMc;
			
			/* init */
			addChild(skin);
			addChild(pageSlider);
			getJSON();			
			
			
			
			//stage.focus = skin.msg_mc.msg_txt;
			//skin.msg_mc.msg_txt.setSelection(0,skin.msg_mc.msg_txt.text.length);
			
			skin.nextButton.addEventListener(MouseEvent.CLICK,nextPage);
			skin.backButton.addEventListener(MouseEvent.CLICK,prevPage);
			skin.btn_upload.addEventListener(MouseEvent.CLICK,onUpload);
			skin.btn_cancel.addEventListener(MouseEvent.CLICK,onCancel);
			
			
			onStageResize();
			stage.addEventListener(Event.RESIZE,onStageResize);
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		private function onStageResize(e:Event=null):void
		{
			if(stage){
				this.x = (stage.stageWidth/2)-(1000/2);
				//this.y = (stage.stageHeight/2)-(580/2);
			
			//skin.maskMc.x = skin.x+10; 
			//skin.maskMc.y = skin.y+10;
			
				//pageSlider.x = skin.x+151;
				//pageSlider.y = skin.y+143; 
			
			} 
		}
		/*************************************************** 
		*********************INIT FUNCTION******************
		***************************************************/
		private function getJSON():void
		{
			trace("GETJSON"); 
			var urlLoader:URLLoader = new URLLoader(new URLRequest("https://graph.facebook.com/me/friends?access_token="+_token));
			urlLoader.addEventListener(Event.COMPLETE,loaded);			//121958551211780|e5464c1f96e369f2d5ea6925.1-1614587239|qOfyQQg5cnyGQkEKwWBlA4Rqdl4
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,error);
		}
		private function error(e:IOErrorEvent):void
		{
			SIGNAL_ERROR.dispatch();
			trace("ERROR");
		}
		private function loaded(e:Event):void
		{
			trace("LOADED");
			var urlLoader:URLLoader = URLLoader(e.target);
			var array:Array = AdobeJSON.decode(urlLoader.data).data as Array;
			var obj:Object = AdobeJSON.decode(urlLoader.data).data;
			for(var i:uint = 0;i<= array.length-1;i++){
				dataVectorFriendAll.push(array[i]);
				allItemVectorFriend.push(skin.getItem(array[i]));
				trace("allItemVectorFriend = "+allItemVectorFriend[i].uId);
				if(friendUid && friendUid.length>0){
					for(var j:uint=0;j<friendUid.length;j++){
						trace("friendUid = "+friendUid[j]);
						if(String(allItemVectorFriend[i].uId)==String(friendUid[j])){
							selectedItemVectorFriend.push(allItemVectorFriend[i]);
							allItemVectorFriend[i].gotoAndStop(2);
						}
						if(selectedItemVectorFriend.length){
							skin.selectedBtn.bg.num_txt.text = String("("+selectedItemVectorFriend.length+")");
						}
					}
				}
				FBFriendListItemSkin(allItemVectorFriend[i]).SIGNAL_SELECTED.add(selectItem);
			}
			SIGNAL_IMAGE_LOADED.dispatch();
			pageSliderUpdate(allItemVectorFriend);
			skin.textInput.SIGNAL_ONCHANGE_TEXT.add(searchName);
			skin.allBtn.addEventListener(MouseEvent.CLICK,changeToAllMode);
			skin.selectedBtn.addEventListener(MouseEvent.CLICK,changeToSeletedMode);
		}
		private function pageSliderUpdate(itemVector:Vector.<FBFriendListItemSkin>):void
		{
			pageSlider.resetItemVector();
			pageSlider.addItemVector(Vector.<DisplayObjectContainer>(itemVector));
			pageSlider.update();
		}
		
		private function selectItem(item:FBFriendListItemSkin,isSelected:Boolean):void
		{
			trace("8888888888 = "+item.uId);
			/*for(var i:uint = 0;i<selectedItemVectorFriend.length;i++){
				
				selectedItemVectorFriend[0].gotoAndStop(1);
			}
			selectedItemVectorFriend = new Vector.<FBFriendListItemSkin>; 
			selectedItemVectorFriend.push(item);*/
			//pageSlider.resetItemVector();
			//pageSlider.addItemVector(Vector.<DisplayObjectContainer>(selectedItemVectorFriend));
			//pageSlider.updateItemLength();
			
			if(isSelected){
				if(selectedItemVectorFriend.length<10){
					selectedItemVectorFriend.push(item);
				}else{
					item.gotoAndStop(1);
					//Alert.show("เลือกเพื่อน 10 คนเท่านั้น");
				}
			
			}else{
				item.gotoAndStop(1);
				//selectedItemVectorFriend[0].SELECTED = false;
				selectedItemVectorFriend.splice(selectedItemVectorFriend.indexOf(item),1);
				pageSlider.resetItemVector();
				//pageSlider.addItemVector(Vector.<DisplayObjectContainer>(selectedItemVectorFriend));
				pageSlider.updateItemLength();
				trace("mode = "+mode);
				if(mode == SELETED){
					skin.allBtn.gotoAndStop(1);
					skin.selectedBtn.gotoAndStop(2);
					item.parent.removeChild(item);
				}else{
					skin.allBtn.gotoAndStop(2);
					skin.selectedBtn.gotoAndStop(1);				
				}
				
			}
			if(selectedItemVectorFriend.length){
				skin.selectedBtn.bg.num_txt.text = String("("+selectedItemVectorFriend.length+")");
			}
		}
		public function cancelSelected(item:FBFriendListItemSkin):void
		{
			item.gotoAndStop(1);
			selectedItemVectorFriend.splice(selectedItemVectorFriend.indexOf(item),1);
		}
		private function changeToAllMode(e:MouseEvent):void
		{			
			skin.allBtn.bg.gotoAndStop(2);
			skin.selectedBtn.bg.gotoAndStop(1);
			skin.textInput.value = "";
			pageSliderUpdate(allItemVectorFriend); 
			mode = ALL;
			if(selectedItemVectorFriend.length){
				skin.selectedBtn.bg.num_txt.text = String("("+selectedItemVectorFriend.length+")");
			}
		}
		private function changeToSeletedMode(e:MouseEvent):void
		{	
			skin.allBtn.bg.gotoAndStop(1);
			skin.selectedBtn.bg.gotoAndStop(2);
			skin.textInput.value = "";
			pageSliderUpdate(selectedItemVectorFriend);
			mode = SELETED
			if(selectedItemVectorFriend.length){
				skin.selectedBtn.bg.num_txt.text = String("("+selectedItemVectorFriend.length+")");
			}
		}
		private function searchName(textInput:TextInput,str:String):void
		{
			trace("searching..."+str);
			searchItemVectorFriend = new Vector.<FBFriendListItemSkin>;
			for(var i:uint=0;i<=dataVectorFriendAll.length-1;i++){
				if(dataVectorFriendAll[i].name.toLowerCase().indexOf(str.toLowerCase()) != -1){
					//trace(dataVectorFriendAll[i].locale);
					searchItemVectorFriend.push(allItemVectorFriend[i]);
				}
			}
			pageSliderUpdate(searchItemVectorFriend);
			mode = SEARCH;
		}
		private function onUpload(e:MouseEvent):void
		{
			var uid:Vector.<String> = new Vector.<String>();
			for(var i:uint=0;i<selectedItemVectorFriend.length;i++){
				uid.push(selectedItemVectorFriend[i].uId);
			}
			SIGNAL_UPLOAD.dispatch(uid);
		}
		private function onCancel(e:MouseEvent):void
		{
			SIGNAL_CANCEL.dispatch();
		}
		private function nextPage(e:MouseEvent):void
		{
			pageSlider.nextPage();
		}
		private function prevPage(e:MouseEvent):void
		{
			pageSlider.prevPage();
		}
		private function dispose(e:Event):void
		{
			if(stage) stage.removeEventListener(Event.RESIZE,onStageResize);
			removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		
		
		public function get selectedFriendsVectorName():Vector.<String>
		{
			var fName:Vector.<String> = new Vector.<String>();
			for(var i:uint=0;i<selectedItemVectorFriend.length;i++){
				fName.push(selectedItemVectorFriend[i].uName);
			}
			return fName;
		}
		public function get selectedFriendsVectorUid():Vector.<String>
		{
			var uid:Vector.<String> = new Vector.<String>();
			for(var i:uint=0;i<selectedItemVectorFriend.length;i++){
				uid.push(selectedItemVectorFriend[i].uId);
			}
			return uid;
		}
			
	}
}