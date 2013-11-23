package model
{
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;

	public class MainModel
	{
		public static const PAGE_ROOM:String = "pageroom";
		public static const PAGE_GAME:String = "pagegame";
		
		public var isCreator:Boolean = false;
		
		private var signalChangePage:Signal = new Signal(String);
		private var signalFreeze:Signal = new Signal(Boolean);
		private var signalPopup:Signal = new Signal(Sprite);
		
		private static var instance:MainModel;
		private static var canInit:Boolean = false;
		private var _currentPage:String = "";
		public function MainModel()
		{
			if( !canInit ){
				throw new Error("Use get instance instead !!!");
			}
		}
		
		public static function getInstance():MainModel
		{
			if( instance==null ){
				canInit = true;
				instance = new MainModel();
				canInit = false;
			}
			return instance;
		}
		
		public function changePage(_page:String):void
		{
			trace(" MainModel : changePage("+_page+")");
			if( _currentPage != _page ){
				signalChangePage.dispatch(_page);
				_currentPage = _page;
			}
		}
		
		public function addChangePageCallback(_callback:Function):void
		{
			signalChangePage.add(_callback);
		}
		
		
		public function freeze():void
		{
			trace(" MainModel : freeze()");
			signalFreeze.dispatch(true);
		}
		
		public function unfreeze():void
		{
			trace(" MainModel : unfreeze()");
			signalFreeze.dispatch(false);
		}
		
		public function addFreezeCallback(_callback:Function):void
		{
			signalFreeze.add(_callback);
		}
	}
}