package module.gamepage
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.PublicMessageRequest;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import module.IPage;
	
	import net.area80.ui.component.Scrollbar;
	import net.area80.ui.skin.ScrollBarSkin;

	public class GamePage2 extends gamePage implements IPage
	{
		private const MAX_PLAYER:int = 5;
		
		private var gameConnector:GameConnector;
		private var sfs:SmartFox;
		
		private var mySeatIndex:int = -1;
		private var scrbar:Scrollbar;
		
		private var currentBtn:int = 0;
		
		public function GamePage2()
		{
		}
		
		private function tester():void
		{
			// button
			var seat1:TextField = createText("1",function():void{
				gameConnector.sit(0,"12344"," { \"status\":\"123\"}");
			});
			var seat2:TextField = createText("2",function():void{
				gameConnector.sit(1,"445434"," { \"status\":\"265\"}");
			});
			var seat3:TextField = createText("3",function():void{
				gameConnector.sit(2,"13343"," { \"status\":\"335\"}");
			});
			var standup:TextField = createText("stand up",function():void{
				gameConnector.standUp();
			});
			var deal:TextField = createText("deal",function():void{
				gameConnector.deal(10);
			});
			
			
			// signal callback
			gameConnector.signalSitComplete.add(function( playerSitData:PlayerSitData ):void{
				trace(" userId:"+playerSitData.userId+" fbuid:"+playerSitData.fbuid+" sit at positionId:"+playerSitData.sitPosition +" playerStatus:"+playerSitData.playerStatus+ " isMe:"+playerSitData.isMe);
			});
			gameConnector.signalSitError.add(function(reason:String):void{
				trace(" sit error : "+reason);
			});
			gameConnector.signalStandUp.add(function(user:User):void
			{
				trace(" user stand up id : "+user.id);
			});
			
			gameConnector.signalStartWithConfig.add( function(_config:String):void{
				trace(" start with config : "+_config);
			});
			gameConnector.signalStartUserTurn.add( function(sitPosition:int):void{
				trace(" start user turn ... sitPosition="+sitPosition);
			});
			gameConnector.signalUserDeal.add(function(value:int , sitPosition:int , turn:int):void
			{
				trace(" user deal : "+value+"  frome user position : "+sitPosition+" turn:"+turn);
			});
			gameConnector.signalEndTurn.add(function():void
			{
				trace(" end turn");
			});
			
			
			gameConnector.signalStandUp.add(function(user:User):void{
				trace(" stand up");
			});
		}
		
		public function start():void
		{
			sfs = ServerConnector.getInstace().smartFoxClient;
			gameConnector = new GameConnector( sfs );
			
			tester();
			
			addChild( new SlotMachineComponent() );
			setUpMessage();
		}
		
		
		/**
		 * MESSAGE 
		 */		
		private function setUpMessage():void
		{
			sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE , onPublicMessage );
			
			sendBtn.addEventListener(MouseEvent.CLICK , sendMsg );
			sendBtn.buttonMode = true;
			messageInputText.addEventListener(KeyboardEvent.KEY_UP,sendMsgByKeyboard );
			
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
				sfs.send(request);
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
		
		public function dispose():void
		{
			
		}
		
		
		
		private function createText(_name:String,_onClick:Function):TextField
		{
			var tf:TextField = new TextField();
			tf.text = _name;
			tf.x = currentBtn*50;
			tf.border = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.addEventListener(MouseEvent.CLICK,_onClick);
			
			var tft:TextFormat = new TextFormat();
			tft.size = 20;
			tft.bold = true;
			tft.color = 0xFFFFFF;
			tf.setTextFormat(tft);

			addChild(tf);
			currentBtn++;
			return tf;
		}
	}
}