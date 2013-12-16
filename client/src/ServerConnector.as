package
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.requests.CreateRoomRequest;
	import com.smartfoxserver.v2.requests.JoinRoomRequest;
	import com.smartfoxserver.v2.requests.LoginRequest;
	import com.smartfoxserver.v2.requests.LogoutRequest;
	import com.smartfoxserver.v2.requests.RoomExtension;
	import com.smartfoxserver.v2.requests.game.SFSGameSettings;
	import com.smartfoxserver.v2.util.ConfigData;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.MainModel;
	
	import org.osflash.signals.Signal;
	
//	http://198.57.254.131:8080/admin/AdminTool.html
//	user: sfsadmin_nok
//	password: admin_noks
	
//	ip: 198.57.254.131
//	user: admin@sf.texasgenius.com
//	password: xA{*2TC$l2Sf
	
//	fip : ftp.texasgenius.com
//	user : home@texasgenius.com
//	pass : UZcyu0brSvmK8tm6HCfL

	public class ServerConnector
	{
		public var isServerStarted:Boolean = false;
		
		private var _user:String;
		
		public const SIGNAL_ROOM_JOIN:Signal = new Signal(Room);
		public const SIGNAL_ROOM_LIST_UPDATE:Signal = new Signal();
		public const SIGNAL_ROOM_USER_COUNT_CHANGE:Signal = new Signal(Room);
		/*public const SIGNAL_ROOM_ADDED:Signal = new Signal(Room);
		public const SIGNAL_ROOM_LIST_UPDATE:Signal = new Signal(SFSEvent);
		public const SIGNAL_ROOM_DELETED:Signal = new Signal(Room);
		public const SIGNAL_ROOM_JOINED:Signal = new Signal(Room);
		public const SIGNAL_ROOM_USER_COUNT_CHANGE:Signal = new Signal(Room);
		*/
		
		// Connection constants
		private const SERVER_IP:String = "192.168.0.13";// "198.57.254.131";//"192.168.0.13";//// "203.170.193.44";
		private const SERVER_PORT:int = 9933;//9339;//
		private const LOBBY_ROOM:String = "The Lobby";
		private const GAME_ROOMS_GROUP_NAME:String = "default";
//		private const DEFAULT_ZONE:String = "z3";
//		private const EXTENSION_ID:String = "MyExt";
//		private const EXTENSIONS_CLASS:String = "com.exitapplication.MyExtension";
		private const DEFAULT_ZONE:String = "BasicExamples";
		private const EXTENSION_ID:String = "texas";//"tris";
		private const EXTENSIONS_CLASS:String = "com.exitapplication.TexasExtension";//"sfs2x.extensions.games.tris.TrisExtension";
		
		private var sfs:SmartFox;
		private var roomListEvent:SFSEvent;
		private var _currentRoom:Room;
		
		private static var _instance:ServerConnector;

		private var configData:ConfigData;
		
		private var waitingJoinRoomName:String = "";
		
		public function ServerConnector()
		{
			if( _instance ){
				throw new Error("Use getInstance instead !!! ");
			}
		}
		
		public static function getInstace():ServerConnector
		{
			if( !_instance ){
				_instance = new ServerConnector();
			}
			return _instance;
		}
		
		public function start(_user:String):void
		{
			this._user = _user;
			configData = new ConfigData();
			configData.host = SERVER_IP;
			configData.port = SERVER_PORT;
			configData.zone = DEFAULT_ZONE;
			configData.httpPort = 8080;
			configData.useBlueBox = true;
			configData.blueBoxPollingRate = 500;
			
			sfs = new SmartFox(false);
			
			sfs.addEventListener(SFSEvent.CONNECTION, onConnection);
			sfs.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_SUCCESS, onConfigLoadSuccess);
			sfs.addEventListener(SFSEvent.CONFIG_LOAD_FAILURE, onConfigLoadFailure);
			sfs.addEventListener(SFSEvent.LOGIN, onLogin);
			
			sfs.addEventListener(SFSEvent.ROOM_ADD, onRoomAdded);
			sfs.addEventListener(SFSEvent.ROOM_REMOVE, onRoomRemoved);
			sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE , onRoomGroupSubscribe );
			sfs.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
			sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);
//			sfs.addEventListener(SFSEvent.SPECTATOR_TO_PLAYER, onRoomJoin);
			
			sfs.addEventListener(SFSEvent.USER_COUNT_CHANGE , onUserCountChange );
			
			sfs.loadConfig("config/sfs-config.xml");
//			sfs.connectWithConfig(configData);
		}
		
		public function backHome( onComplete:Function ):void
		{
			var onJoinRoom:Function = function():void{
				onComplete();
				SIGNAL_ROOM_JOIN.remove(onJoinRoom);
			};
			SIGNAL_ROOM_JOIN.add(onJoinRoom);
			changeZone(DEFAULT_ZONE);
			
			MainModel.getInstance().changePage(MainModel.PAGE_GAME);
		}
		
		protected function onUserCountChange(event:SFSEvent):void
		{
			Shows.addByClass(this,"onUserCountChange room="+ event.params.room.name);
			SIGNAL_ROOM_USER_COUNT_CHANGE.dispatch(event.params.room);
		}
		
		/**
		 * LOAD CONFIGDATA 
		 */		
		
		protected function onConfigLoadSuccess(event:SFSEvent):void
		{
			Shows.addByClass(this,"onConfigLoadSuccess");
		}		
		
		protected function onConfigLoadFailure(event:SFSEvent):void
		{
			Shows.addByClass(this,"onConfigLoadFailure:"+event.params);
		}
		
		/*public function login(_zone:String):void
		{
			configData.zone = _zone;
			sfs.connectWithConfig(configData);
		}*/
		
		
		protected function onConnection(evt:SFSEvent):void
		{
			Shows.addByClass(this,"ServerConnection connection : evt="+evt);
			if( !evt || !evt.params ){
				Shows.addByClass(this,"ServerConnection connection() error");
				return;
			}
			var ok:Boolean = evt.params.success;
			Shows.addByClass(this," onConnection:"+ok);
			if( ok ){
				Shows.addByClass(this," logging in... ");
				sfs.send( new LoginRequest(_user,"",DEFAULT_ZONE) );
			}else{
				onConnectionLost();
			}
		}
		
		protected function onLogin(evt:SFSEvent):void
		{
			Shows.addByClass(this,"onLogin");
			Shows.addByClass(this,"sfs.roomManager.containsGroup(GAME_ROOMS_GROUP_NAME) : "+sfs.roomManager.containsGroup(GAME_ROOMS_GROUP_NAME));
			/*if (!sfs.roomManager.containsGroup(GAME_ROOMS_GROUP_NAME))
				sfs.send(new SubscribeRoomGroupRequest(GAME_ROOMS_GROUP_NAME));*/
			sfs.send( new JoinRoomRequest(LOBBY_ROOM) );
		}
		
		
		
		
		
		/**
		 * ROOM 
		 */		
		public function changeZone(_zone:String):void
		{
			var onLoggedOut:Function=function(e:SFSEvent):void{
				Shows.addByClass(this," onLoggedOut : to zone:"+_zone);
				sfs.removeEventListener(SFSEvent.LOGOUT , onLoggedOut );
				var request:LoginRequest = new LoginRequest(_user,"",_zone);
				sfs.send(request);
			};
			sfs.addEventListener(SFSEvent.LOGOUT , onLoggedOut );
			sfs.send( new LogoutRequest() );
			Shows.addByClass(this," zone:"+_zone);
		}
		
		public function createRoom(_name:String):void
		{
			// Create the room!
			// Create game settings
			var settings:SFSGameSettings = new SFSGameSettings(_name);
			settings.groupId = GAME_ROOMS_GROUP_NAME;
//			settings.password = createGamePanel.ti_password.text;
			settings.isGame = true;
			settings.maxUsers = 20;
			settings.maxSpectators = 10;
			
			settings.extension = new RoomExtension(EXTENSION_ID, EXTENSIONS_CLASS);
			
			waitingJoinRoomName = _name;	
			// Create room
			var request:CreateRoomRequest = new CreateRoomRequest(settings, false, sfs.lastJoinedRoom);
			sfs.send(request);
		}
		
		public function join(_id:int ):void
		{
			var request:JoinRoomRequest = new JoinRoomRequest(_id, null, sfs.lastJoinedRoom.id , true );
			sfs.send(request);
		}
		
		protected function onRoomJoin(event:SFSEvent):void
		{
			_currentRoom = event.params.room;
			
			var updatedUser:User = sfs.mySelf;
			Shows.addByClass(this,"onRoomJoin isSpectator : "+updatedUser.isSpectator);
			
			isServerStarted = true;
			
			SIGNAL_ROOM_JOIN.dispatch(_currentRoom);
			updateRoomList();
		}
		
		
		protected function onRoomJoinError(event:SFSEvent):void
		{
			Shows.addByClass(this,"onRoomJoinError"+event.params.reason);
		}
		
		private function onRoomAdded(evt:SFSEvent):void
		{
			var room:Room = evt.params.room;
//			var label:String = room.() + " (" + room.getUserCount() + "/" + room.getMaxUsers() + ")";
			Shows.addByClass(this," ___ [onRoomAdded]"+room.groupId+" , "+room.name+" , "+room.userCount+" , "+room.maxUsers);
			updateRoomList();
			
			if( room.name == waitingJoinRoomName ){
				waitingJoinRoomName="";
				join(room.id);
			}
		}
		
		protected function onRoomRemoved(event:SFSEvent):void
		{
			var room:Room = event.params.room;
			//			var label:String = room.() + " (" + room.getUserCount() + "/" + room.getMaxUsers() + ")";
			Shows.addByClass(this," ___ [onRoomRemoved]"+room.groupId+" , "+room.name+" , "+room.userCount+" , "+room.maxUsers);
			updateRoomList();
		}
		
		protected function onRoomGroupSubscribe(event:SFSEvent):void
		{
			Shows.addByClass(this," ___ [onRoomGroupSubscribe]");
		}
		
		private function updateRoomList():void
		{
			Shows.addByClass(this,"___[updateRoomList]");
			SIGNAL_ROOM_LIST_UPDATE.dispatch();
		}
		
		
		
		
		public function logout():void
		{
			sfs.disconnect();
		}
		
		
		protected function onLogout(event:Event):void
		{
		}
		
		
		/*
		* Handle disconnection
		*/
		protected function onConnectionLost(evt:SFSEvent=null):void
		{
			Shows.addByClass(this,"connection lost");
			navigateToURL( new URLRequest("http://www.texasgenius.com"),"_self" );
		}
		
		public function get smartFoxClient():SmartFox
		{
			return sfs;
		}
		
		
		public function get currentRoom():Room { return _currentRoom; }
	}
}