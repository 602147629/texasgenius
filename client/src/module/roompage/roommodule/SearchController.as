package module.roompage.roommodule
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	import module.roompage.RoomPage;
	
	import net.area80.utils.StringUtils;

	public class SearchController
	{
		private var searchMc:MovieClip;
		private var searchTf:TextField;
		private var searchBtn:MovieClip;
		public function SearchController(roomPage:RoomPage)
		{
			searchMc = roomPage.searchMc;
			searchTf = roomPage.searchMc["serachTf"];
			searchBtn = roomPage.searchBtn;
			
			searchMc.alpha = 0;
			searchTf.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			searchTf.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			searchTf.addEventListener(Event.CHANGE,onSearch);
		}
		
		protected function onFocusIn(event:FocusEvent):void
		{
			searchMc.alpha=1;
		}
		
		protected function onFocusOut(event:FocusEvent):void
		{
			if( searchTf.length==0 ){
				searchMc.alpha=0;
			}
		}
		
		protected function onSearch(event:Event=null):void
		{
			RoomPageModel.getInstance().searchString = StringUtils.trim(searchTf.text);
			RoomPageModel.getInstance().signalUpdateRoom.dispatch();
		}
		
	}
}