package module.roompage.usergamemodule
{
	import flash.display.Sprite;
	
	import EXIT.util.JSONLoader;
	
	import module.roompage.friendmodule.FriendData;
	
	import net.area80.ui.component.Scrollbar;
	import net.area80.ui.skin.ScrollBarSkin;

	public class PeopleController
	{
		private var view:Sprite;
		private var container:Sprite;
		private var maskPeople:Sprite;
		public function PeopleController(_view:Sprite)
		{
			view = _view;
			container = new Sprite();
			view.addChild(container);
			maskPeople = _view["maskPeople"];
			
			container.mask = maskPeople;
			view["scrbar"].visible = false;
			
			var jsonLoader:JSONLoader = new JSONLoader("https://graph.facebook.com/"+UserData.fbuid+"?fields=friends&access_token="+UserData.access_token);
			jsonLoader.signalComplete.add(getFriendList);
			jsonLoader.load();
		}
		
		private function getFriendList(_data:*):void
		{
			view["scrbar"].visible = true;
			var peopleDataArray:Array = _data.friends.data;
			var _length:int = peopleDataArray.length;
			if( _length > 20 ){
				_length = 20;
			}
			for( var i:int=0 ; i<=_length-1 ; i++ ){
				var peopleItem:PeopleItem = new PeopleItem(peopleDataArray[i].name,peopleDataArray[i].id);
				peopleItem.x = 5;
				peopleItem.y = 67*i;
				container.addChild(peopleItem);
				
			}
			var scrbarSkin:ScrollBarSkin = new ScrollBarSkin();
			scrbarSkin.arrowUp = view["scrbar"]["arrowUp"];
			scrbarSkin.scrubber = view["scrbar"]["scrubber"];
			scrbarSkin.bgScrollBar = view["scrbar"]["bgScrollBar"];
			scrbarSkin.arrowDown = view["scrbar"]["arrowDown"];
			scrbarSkin.addChild(scrbarSkin.arrowUp);
			scrbarSkin.addChild(scrbarSkin.scrubber);
			scrbarSkin.addChild(scrbarSkin.bgScrollBar);
			scrbarSkin.addChild(scrbarSkin.arrowDown);
			var scrbar:Scrollbar = new Scrollbar(container,maskPeople,scrbarSkin);
			view.addChild(scrbar);
		}
		
		
		public function enable():void
		{
			view.visible = true;
		}
		
		public function disable():void
		{
			view.visible = false;
		}
	}
}