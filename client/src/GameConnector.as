package
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.PlayerToSpectatorRequest;
	import com.smartfoxserver.v2.requests.SpectatorToPlayerRequest;
	
	import module.gamepage.PlayerSitData;
	
	import org.osflash.signals.Signal;
	
//http://www.smartfoxserver.com/forums/viewtopic.php?f=18&t=16204
	public class GameConnector
	{
		/**
		 * 1 int > userId who sit <br>
		 * 2 int > sitPosition <br>
		 * 4 String > playerstatus
		 * 4 Boolean > isMe
		 */		
		public var signalSitComplete:Signal = new Signal(PlayerSitData);
		
		/**
		 * 1 String > error description 
		 */		
		public var signalSitError:Signal = new Signal(String);
		
		/**
		 * User > who is stand up. 
		 */		
		public var signalStandUp:Signal = new Signal(User);
		
		
		/**
		 * 1 String > Config that is loaded from server. 
		 */		
		public var signalStartWithConfig:Signal = new Signal(String);
		/**
		 * 1 int > seat position
		 */		
		public var signalStartUserTurn:Signal = new Signal(int);
		
		/**
		 * 1 int > deal value if 0 mean "หมอบ"<br>
		 * 2 int > seat position. <br>
		 * 3 int > turns
		 */		
		public var signalUserDeal:Signal = new Signal(int,int,int);
		
		
		/**
		 * 
		 */		
		public var signalEndTurn:Signal = new Signal();
		
		
		//server send
		private const ON_SIT_COMPLETE:String  = "onsitcomplete";
		private const ON_SIT_ERROR:String = "onsiterror";
		private const PROVIDE_CONFIG:String  = "provideconfig";
		
		private const START_GAME_TURN:String  = "startgameturn";
		private const START_USER_TURN:String = "startuserturn";
		private const END_TURN:String  = "endturn";
		
		//client send
		private const USER_SIT:String  = "usersit"; 
		private const USER_DEAL:String  = "userdeal";
		
		//client var
		private const SIT_POSITION:String = "sitposition";
		private const PLAYER_STATUS:String = "playerstatus";
		private const FB_UID:String = "fbuid";
		private const USER_ID:String = "userid";
		private const CONFIG_DATA:String = "configdata";
		private const REASON:String = "reason";
		private const VALUE:String = "value";
		private const TURN:String = "turn";
		
		private var sfs:SmartFox;
		private var sitPosition:int;
		private var playerStatus:String;
		private var fbuid:String;
		
		public function GameConnector(sfs:SmartFox)
		{
			this.sfs = sfs;
			
			sfs.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
			sfs.addEventListener(SFSEvent.SPECTATOR_TO_PLAYER, onSpectatorToPlayer);
			sfs.addEventListener(SFSEvent.PLAYER_TO_SPECTATOR, onPlayerToSpectator);
			sfs.addEventListener(SFSEvent.SPECTATOR_TO_PLAYER_ERROR, onSpectatorToPlayerError);
		}
		
		
		
		/**
		 * SIT
		 */		
		
		public function sit( _sitPosition:int , _fbuid:String , _playerStatus:String ):void
		{
			sitPosition = _sitPosition;
			fbuid = _fbuid;
			playerStatus = _playerStatus;
			sfs.send( new SpectatorToPlayerRequest(sfs.lastJoinedRoom) );
		}
		
		protected function onSpectatorToPlayer(event:SFSEvent):void
		{
			var updatedUser:User = event.params.user as User
			Shows.addByClass(this,"onSpectatorToPlayer isMe : "+updatedUser.isItMe);
			if (updatedUser.isItMe){
				var sfsObj:SFSObject = new SFSObject();
				sfsObj.putInt(SIT_POSITION,sitPosition);
				sfsObj.putUtfString(FB_UID,fbuid);
				sfsObj.putUtfString(PLAYER_STATUS,playerStatus);
				sfs.send( new ExtensionRequest( USER_SIT , sfsObj , sfs.lastJoinedRoom) );
			}
		}
		
		protected function onSpectatorToPlayerError(event:SFSEvent):void
		{
			Shows.addByClass(this,"onSpectatorToPlayerError");
			var updatedUser:User = event.params.user as User
			if (updatedUser.isItMe){
				signalSitError.dispatch( "i don't know" );
			}
		}
		
		
		
		
		/**
		 * STAND UP
		 */		
		
		public function standUp():void
		{
			sfs.send( new PlayerToSpectatorRequest(sfs.lastJoinedRoom) );
		}
		
		protected function onPlayerToSpectator(event:SFSEvent):void
		{
			var user:User = event.params.user as User
			Shows.addByClass(this,"onSpectatorToPlayer isMe : "+user.isItMe);
			signalStandUp.dispatch(user);
		}
		
		
		
		/**
		 * if deal value = 0 คือหมอบ 
		 */		
		public function deal(_value:int):void
		{
			var sfsObj:SFSObject = new SFSObject();
			sfsObj.putInt(VALUE,_value);
			sfs.send( new ExtensionRequest( USER_DEAL , sfsObj , sfs.lastJoinedRoom) );
		}
		
		public function getMyId():int { return sfs.mySelf.id; }
		
		private function onExtensionResponse(evt:SFSEvent):void
		{
			var params:ISFSObject = evt.params.params
			var cmd:String = evt.params.cmd
			var sitPosition:int;
			var userId:int;
			switch(cmd)
			{
				case "test" :
					Shows.addByClass(this," test : v="+params.getUtfString("t")+" ... "+params.getUtfString("data"));
					break;
				case ON_SIT_COMPLETE :
					userId = params.getInt(USER_ID);
					var fbuid:String = params.getUtfString(FB_UID);
					sitPosition = params.getInt(SIT_POSITION);
					var playerStatus:String = params.getUtfString(PLAYER_STATUS);
					var sitPlayerData:PlayerSitData = new PlayerSitData( userId , fbuid , sitPosition , playerStatus , sfs.mySelf.id==userId );
					signalSitComplete.dispatch(sitPlayerData);
				break;
				case ON_SIT_ERROR :
					signalSitError.dispatch(params.getUtfString(REASON));
				break;
				case START_GAME_TURN :
					signalStartWithConfig.dispatch(params.getUtfString(CONFIG_DATA));
				break;
				case START_USER_TURN :
					sitPosition = params.getInt(SIT_POSITION);
					signalStartUserTurn.dispatch(sitPosition);
				break;
				case PROVIDE_CONFIG :
					//signalStartWithConfig.dispatch(params.getUtfString(CONFIG_DATA));
				break;
				case USER_DEAL :
					signalUserDeal.dispatch( params.getInt(VALUE) , params.getInt(SIT_POSITION) , params.getInt(TURN) );
				break;
				case END_TURN :
					signalEndTurn.dispatch();
				break;
			}
		}
	}
}