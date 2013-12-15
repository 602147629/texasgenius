package module.gamepage
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.PublicMessageRequest;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import module.IPage;
	
	import net.area80.display.loader.ImageBox;
	import net.area80.ui.component.Scrollbar;
	import net.area80.ui.skin.ScrollBarSkin;

	public class GamePage extends gamePage implements IPage
	{
		private const MAX_PLAYER:int = 5;
		
		private var serverConnector:ServerConnector;
		private var extensionName:String = "texusgame";
		
		private var mySeatIndex:int = -1;

		private var scrbar:Scrollbar;
		
		public function GamePage()
		{
			
		}
		
		public function start():void
		{
			serverConnector = ServerConnector.getInstace();
//			serverConnector.smartFoxClient.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponse);
			serverConnector.smartFoxClient.addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitRoom );
			serverConnector.smartFoxClient.addEventListener(SFSEvent.USER_ENTER_ROOM , onUserEnterRoom );
			serverConnector.smartFoxClient.addEventListener(SFSEvent.PUBLIC_MESSAGE , onPublicMessage );
			serverConnector.smartFoxClient.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
			/*
			
			
			Shows.add("GamePage:"+serverConnector.smartFoxClient.activeRoomId);
			serverConnector.smartFoxClient.sendXtMessage(extensionName, "ready", null);
			
			setTimeout(function():void{
				serverConnector.smartFoxClient.sendXtMessage(extensionName, "testttt", {data:"userupdate"},"xml",serverConnector.smartFoxClient.activeRoomId);
			},2000);
			
			for( var i:int=1 ; i<=MAX_PLAYER ; i++ ){
				this["player"+i].visible = false;
			}
			*/
			sendBtn.addEventListener(MouseEvent.CLICK , sendMsg );
			sendBtn.buttonMode = true;
			messageInputText.addEventListener(KeyboardEvent.KEY_UP,sendMsgByKeyboard );
			
			updateUserPosition();
			
			var scrbarSkin:ScrollBarSkin = new ScrollBarSkin();
			scrbarSkin.arrowUp = arrowUp;
			scrbarSkin.scrubber = scrubber;
			scrbarSkin.bgScrollBar = bgScrollBar;
			scrbarSkin.arrowDown = arrowDown;
			scrbarSkin.addChild(scrbarSkin.bgScrollBar);
			scrbarSkin.addChild(scrbarSkin.arrowUp);
			scrbarSkin.addChild(scrbarSkin.scrubber);
			scrbarSkin.addChild(scrbarSkin.arrowDown);
			
			allMessageMc.mask = maskMc;
			scrbar = new Scrollbar(allMessageMc,maskMc,scrbarSkin);
			addChild(scrbar);
			
			
			/*var loader:Loader = new Loader();
			loader.load( new URLRequest("slot.swf") );
			addChild(loader);*/
			addChild( new SlotMachineComponent() );
			
			setTimeout( function():void
			{
				var sfso:ISFSObject = new SFSObject();
				sfso.putUtfString("data",'{'+
									   '"id": "547822084",'+
									   '"name": "Ekkasit Exit Pinyoanuntapong",'+
									   '"first_name": "Ekkasit",'+
									   '"middle_name": "Exit",'+
									   '"last_name": "Pinyoanuntapong",'+
									   '"username": "exit.pinyoanuntapong",'+
									   '"gender": "male",'+
									   '"locale": "en_US"'+
									'}');
				serverConnector.smartFoxClient.send( new ExtensionRequest("test", sfso, serverConnector.smartFoxClient.lastJoinedRoom) );
				
				Shows.addByClass(this," send math ext... ");
			},1000);
		}
		
		protected function sendMsgByKeyboard(event:KeyboardEvent):void
		{
			if( event.charCode==Keyboard.ENTER ){
				sendMsg();
			}
		}
		
		protected function sendMsg(event:MouseEvent=null):void
		{
			if( messageInputText.text != "" ){
//				serverConnector.smartFoxClient.sendPublicMessage( messageInputText.text ,serverConnector.smartFoxClient.activeRoomId);
				
				var params:ISFSObject = new SFSObject();
				params.putUtfString("c", myColorMessage);
				
				var request:PublicMessageRequest = new PublicMessageRequest(messageInputText.text, params);
				serverConnector.smartFoxClient.send(request);
				messageInputText.text = "";
			}
		}
		
		protected function onPublicMessage(event:SFSEvent):void
		{
			var subParams:ISFSObject = event.params.data;
			var colorCode:String = (subParams != null ? subParams.getUtfString("c") : "#000000");
			
//			showPublicChatMessage(evt.params.message, evt.params.sender, colorCode);
			
			var message:String = event.params.message;
			var sender:User = event.params.sender;
			TextField(allMessageMc["allMessageText"]).htmlText += "<font color='"+colorCode+"'><b>" + sender.name.split("_")[1] + ":</b> " + message +"<br></font>";
			Shows.addByClass(this," onPublicMessage : "+"<b>[onPublicMessage " + sender.name + "]:</b> " + message +"<br>");
			TextField(allMessageMc["allMessageText"]).autoSize = TextFieldAutoSize.LEFT;
			
			allMessageMc.y = maskMc.y + maskMc.height - allMessageMc.height;
			scrbar.updateStatus();
		}
		
		protected function onUserEnterRoom(event:SFSEvent):void
		{
			Shows.addByClass(this,"onUserEnterRoom");
			updateUserPosition();
		}
		
		private function updateUserPosition():void
		{
			var players:Array = serverConnector.currentRoom.userList;
			var currentPlayerIndex:int = 1;
			for( var i:int=1 ; i<=players.length ; i++ ){
				var player:User = players[i-1];
				if( !player.isSpectator ){ 
					if( player.isItMe ){
						mySeatIndex = currentPlayerIndex-1;
					}
					
					Shows.addByClass(this,"updateUserPosition() name:"+player.name+"  id:"+player.id );
					
					this["player"+currentPlayerIndex]["userName"].text = player.name.split("_")[1];
					this["player"+currentPlayerIndex].visible = true;
					
					var profileContainer:Sprite = this["player"+currentPlayerIndex]["profileImage"];
					
					while( profileContainer.numChildren > 1 ){
						var dispo:DisplayObject = profileContainer.getChildAt(1);
						if( dispo is ImageBox ){
							profileContainer.removeChild(dispo);
						}
					}
				
					var image:ImageBox = new ImageBox("https://graph.facebook.com/"+player.name.split("_")[0]+"/picture",50,50);
					profileContainer.addChild(image);
					image.load();
					image.mask = profileContainer["maskMc"];
					
					currentPlayerIndex++;
				}
			}
			for( i=currentPlayerIndex ; i<=MAX_PLAYER ; i++ ){
				this["player"+i].visible = false;
			}
		}
		
		protected function onUserExitRoom(event:SFSEvent):void
		{
			updateUserPosition();
		}
		/*
		protected function onExtensionResponse(event:SFSEvent):void
		{
			Shows.addByClass(this,"________________________________________________________");
			var params:Object = event.params.dataObj;
			var cmd:String = params._cmd;
			Shows.addByClass(this,"onExtensionResponse() GamePage onExtensionResponse : "+cmd);
			Shows.addByClass(this,"--------------------------------------------------------");
		}*/
		
		public function dispose():void
		{
			
		}
		
		
		private function get myColorMessage():String
		{
			var colorString:String;
			if(mySeatIndex==0){
				colorString = "#ff0000";
			}else if(mySeatIndex==1){
				colorString = "#00ff00";
			}else if(mySeatIndex==2){
				colorString = "#0000ff";
			}else if(mySeatIndex==3){
				colorString = "#ffff00";
			}else if(mySeatIndex==4){
				colorString = "#00ffff";
			}
			return colorString;
		}
		
		
		
		
		
		
		
		public function onExtensionResponse(evt:SFSEvent):void
		{
			var params:ISFSObject = evt.params.params
			var cmd:String = evt.params.cmd
			switch(cmd)
			{
				case "math" :
					trace(" sum="+params.getInt("sum"));
					break;
				case "trace" :
					trace(" trace : "+params.getUtfString("t"));
					break;
				case "test" :
					trace(" test : v="+params.getUtfString("t")+" ... "+params.getUtfString("data"));
					break;
			}
		}
	}
}