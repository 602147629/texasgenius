package
{
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import it.gotoandplay.smartfoxserver.SmartFoxClient;
	import it.gotoandplay.smartfoxserver.data.Room;
	
	import org.osflash.signals.Signal;

	public class ServerConnector2x
	{
		private var _user:String;
		
		public const SIGNAL_LOGGED_IN:Signal = new Signal(SFSEvent);
		public const SIGNAL_ROOM_LIST_UPDATE:Signal = new Signal(SFSEvent);
		public const SIGNAL_ROOM_ADDED:Signal = new Signal(Room);
		public const SIGNAL_ROOM_DELETED:Signal = new Signal(Room);
		public const SIGNAL_ROOM_JOINED:Signal = new Signal(Room);
		public const SIGNAL_ROOM_USER_COUNT_CHANGE:Signal = new Signal(Room);
		public const SIGNAL_LOGGED_OUT:Signal = new Signal();
		
		// Connection constants
		private const SERVER_IP:String = "198.57.254.131";//"192.168.0.13";//// "203.170.193.44";
		private const SERVER_PORT:int = 9933;//9339;//
		private const DEFAULT_ZONE:String = "sftris";
		
		private var sfs:SmartFoxClient;
		private var roomListEvent:SFSEvent;
		private var _currentRoomID:int = -1;
		
		private static var _instance:ServerConnector2x;
		public function ServerConnector2x()
		{
			if( _instance ){
				throw new Error("Use getInstance instead !!! ");
			}
		}
	}
}