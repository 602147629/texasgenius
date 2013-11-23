package module.roompage.friendmodule
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import EXIT.util.JSONLoader;
	
	import __AS3__.vec.Vector;
	import module.roompage.RoomPage;

	public class FriendListController
	{
		private const DIFF_ITEM_X:Number = 110;
		private const NUM_ITEM_PER_PAGE:Number = 4;
		
		private var container:Sprite;
		private var friendMoveContainer:Sprite = new Sprite();
		private var currentFriendContainer:Sprite;
		private var friendItems:Vector.<FriendItem>;
		
		private var currentID:int = 0;
		
		public function FriendListController(_container:Sprite,_roomPage:RoomPage)
		{
			container = _container;
			_roomPage.leftLast.addEventListener(MouseEvent.CLICK , goFirst );
			_roomPage.leftTwo.addEventListener(MouseEvent.CLICK , goLeftTwo );
			_roomPage.leftOne.addEventListener(MouseEvent.CLICK , goLeftOne );
			
			_roomPage.rightLast.addEventListener(MouseEvent.CLICK , goLast );
			_roomPage.rightTwo.addEventListener(MouseEvent.CLICK , goRightTwo );
			_roomPage.rightOne.addEventListener(MouseEvent.CLICK , goRightOne );
			
			container.addChild(friendMoveContainer);
			
			var jsonLoader:JSONLoader = new JSONLoader("https://graph.facebook.com/"+UserData.fbuid+"?fields=friends&access_token="+UserData.access_token);
			jsonLoader.signalComplete.add(getFriendList);
			jsonLoader.load();
		}
		
		private function getFriendList(_data:*):void
		{
			var friendDataArray:Array = _data.friends.data;
			var _friendDatas:Vector.<FriendData> = new Vector.<FriendData>();
			for( var i:int=0 ; i<=friendDataArray.length-1 ; i++ ){
				_friendDatas.push( new FriendData(friendDataArray[i].name,"300k",friendDataArray[i].id) );
			}
			initItems(_friendDatas);
		}		
		
		private function initItems(_friendDatas:Vector.<FriendData>):void
		{
			friendItems = new Vector.<FriendItem>();
			for( var i:int=0 ; i<=_friendDatas.length-1 ; i++ ){
				var friendItem:FriendItem = new FriendItem(_friendDatas[i] , (i+1) );
				friendItems.push( friendItem );
				friendItem.x = i*DIFF_ITEM_X;
				friendMoveContainer.addChild(friendItem);
			}
		}
		
		private function gotoX(_id:int):void
		{
			currentID = _id;
			if( currentID<0 ){
				currentID=0;
			}else if(currentID>friendItems.length - NUM_ITEM_PER_PAGE){
				currentID = friendItems.length - NUM_ITEM_PER_PAGE;
			}
			trace(" id"+_id);
			TweenLite.to( friendMoveContainer , .5 , { x: -currentID*DIFF_ITEM_X } );
		}
		
		protected function goFirst(event:MouseEvent):void
		{
			gotoX(0);
		}
		
		protected function goLeftTwo(event:MouseEvent):void
		{
			gotoX(currentID-NUM_ITEM_PER_PAGE);
		}
		
		protected function goLeftOne(event:MouseEvent):void
		{
			gotoX(currentID-1);
		}
		
		
		protected function goLast(event:MouseEvent):void
		{
			gotoX( friendItems.length - NUM_ITEM_PER_PAGE );
		}
		
		protected function goRightTwo(event:MouseEvent):void
		{
			gotoX(currentID+NUM_ITEM_PER_PAGE);
		}
		
		protected function goRightOne(event:MouseEvent):void
		{
			gotoX(currentID+1);
		}
		
	}
}
