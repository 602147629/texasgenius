package module.roompage.roommodule
{
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.SFSRoom;
	
	import flash.display.Sprite;
	
	import __AS3__.vec.Vector;
	
	import net.area80.ui.component.Scrollbar;
	import net.area80.ui.skin.ScrollBarSkin;
	import net.area80.utils.DrawingUtils;
	import net.area80.utils.StringUtils;

	public class RoomController
	{
		private var roomContainer:Sprite = new Sprite();
		private var maskMc:Sprite = DrawingUtils.getRectSprite(550,240);
		
		private var serverConnector:ServerConnector = ServerConnector.getInstace();
		
		private var roomItems:Vector.<RoomList> = new Vector.<RoomList>();
		private var lastRoomItemSelected:RoomList;

		private var scrb:Scrollbar;
		
		
		public function RoomController(_roomSprite:Sprite)
		{
			_roomSprite.addChild(roomContainer);
			_roomSprite.addChild(maskMc);
			roomContainer.mask = maskMc;
			serverConnector.SIGNAL_ROOM_LIST_UPDATE.add( onRoomListUpdate );
			serverConnector.SIGNAL_ROOM_USER_COUNT_CHANGE.add( onRoomUserCountChange );
			RoomPageModel.getInstance().signalUpdateRoom.add(onRoomListUpdate);
			
			var srbAsset:Sprite = new scrbarRoom();
			var scrbSkin:ScrollBarSkin = new ScrollBarSkin();
			scrbSkin.arrowUp = srbAsset["arrowUp"];
			scrbSkin.addChild(scrbSkin.arrowUp);
			scrbSkin.arrowDown = srbAsset["arrowDown"];
			scrbSkin.addChild(scrbSkin.arrowDown);
			scrbSkin.bgScrollBar = srbAsset["bgScrollBar"];
			scrbSkin.addChild(scrbSkin.bgScrollBar);
			scrbSkin.scrubber = srbAsset["scrubber"];
			scrbSkin.addChild(scrbSkin.scrubber);
			scrbSkin.x = 560;
			
			scrb = new Scrollbar(roomContainer,maskMc,scrbSkin);
			_roomSprite.addChild( scrb );
			
		}
		
		private function onRoomListUpdate():void
		{
			Shows.addByClass(this,"RoomController onRoomListUpdate()");
			while(roomContainer.numChildren>0){
				roomContainer.removeChildAt(0);
			}
			
			
			resetRoomSelected();
			roomItems = new Vector.<RoomList>();
			
			var roomList:Array = serverConnector.smartFoxClient.roomManager.getRoomListFromGroup("default");
			var currentItem:int = 0;
			for( var i:int=0 ; i<=roomList.length-1 ; i++ ){
				var room:SFSRoom = SFSRoom(roomList[i]);
//				Shows.addByClass(this,"room:"+room.name+" isgame:"+room.isGame);
				if( room.isGame ){
					if( RoomPageModel.getInstance().searchString == "" || 
						room.id.toString().indexOf( RoomPageModel.getInstance().searchString ) != -1 ||
						room.name.toString().indexOf( RoomPageModel.getInstance().searchString ) != -1
					){
						var roomItem:RoomList = new RoomList( room.id , room.name , room.userCount , room.maxUsers );
						roomItem.y = roomItem.height*currentItem;
						roomContainer.addChild(roomItem);
						
						roomItem.signalSelected.add(chooseRoom);
						roomItems.push( roomItem );
						currentItem++;
					}
				}
			}
			
			var bg:Sprite = DrawingUtils.getRectSprite(roomContainer.width,roomContainer.height);
			roomContainer.addChildAt( bg,0 );
			scrb.updateStatus();
		}
		
		private function chooseRoom(_roomList:RoomList):void
		{
			if(lastRoomItemSelected ){
				lastRoomItemSelected.deSelect();
			}
			_roomList.select();
			lastRoomItemSelected = _roomList;
		}
		
		private function onRoomUserCountChange( _room:Room ):void
		{
			Shows.add("RoomController onRoomUserCountChange()");
			for( var i:int=0 ; i<=roomItems.length-1 ; i++ ){
				if( roomItems[i]._id == _room.id ){
					roomItems[i].update( _room.id , _room.name , _room.userCount , _room.maxUsers );
				}
			}
		}
		
		private function onLoggedOut():void
		{
			
		}
		
		public function dispose():void
		{
			serverConnector.SIGNAL_ROOM_LIST_UPDATE.removeAll();
			serverConnector.SIGNAL_ROOM_USER_COUNT_CHANGE.removeAll();
			serverConnector = null;
			
			RoomPageModel.getInstance().signalUpdateRoom.remove(onRoomListUpdate);
		}
		
		public function getSelectedRoomID():Number
		{
			if( lastRoomItemSelected==null){
				return -1
			}else{
				return lastRoomItemSelected._id;
			}
		}
		
		private function resetRoomSelected():void
		{
			if( lastRoomItemSelected!=null){
				lastRoomItemSelected.deSelect();
				lastRoomItemSelected = null;
			}
		}
	}
}