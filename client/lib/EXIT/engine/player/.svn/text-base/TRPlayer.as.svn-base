package th.co.canon.theremember.core.view.player
{
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.area80.sitemanager.events.TransitionEvent;
	
	import th.co.canon.theremember.core.view.TRDialog;
	import th.co.canon.theremember.core.view.player.asset.CloseButton;
	import th.co.canon.theremember.core.view.player.playerskin.PlayerSkin1;
	import th.co.canon.theremember.core.view.player.playervdo.VdoNetStream;
	import th.co.canon.theremember.core.view.player.playervdo.YoutubePlayer;
	
	
	//[SWF(width="1260",height="700")]
	public class TRPlayer extends TRDialog
	{
		private var videoId:String;
		public var youtube:YoutubePlayer;
		private var playerCtrl:PlayerController;
		public var plns:VdoNetStream;
		private var playerskin:PlayerSkin1;
		private var closebutton:CloseButton;
		//private var container:Sprite;
		private var isYouTube:Boolean;
		
		public function TRPlayer(isYouTube:Boolean=false)
		{
			this.isYouTube = isYouTube;
			addEventListener(TransitionEvent.TRANSITION_IN_COMPLETE, initPlayer);
			
			super(new Sprite());
		}
		protected function initPlayer(event:Event):void
		{
			playerskin = new PlayerSkin1();
			var src:String = commandMap.params as String; 
			if(!src || src==""){
				try {
					var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;     
					videoId = paramObj.action_id;
				} catch (error:Error) {
					
				}
			}else{
				videoId = src;
			}
			if(!videoId || videoId == ""){
				return;
			}
			if(isYouTube){
				if(commandMap) commandMap.track("youtube_"+videoId);
				youtube = new YoutubePlayer(); 
				youtube.loadAndPlay(videoId);
				playerCtrl = new PlayerController(youtube,playerskin,1260,700,null,true);
				playerCtrl.signalEvent.add(onTaggleFullscreen);
				addChild(playerCtrl);
				addChild(playerskin);
			}else{
				if(commandMap) commandMap.track("flv_"+videoId);
				plns = new VdoNetStream(videoId);
				playerCtrl = new PlayerController(plns,playerskin,1260,700,null,true);
				playerCtrl.signalEvent.add(onTaggleFullscreen);
				addChild(playerCtrl);
				addChild(playerskin);	
			}
			closebutton = new CloseButton();
			addChild(closebutton);
			closebutton.buttonMode = true;
			closebutton.addEventListener(MouseEvent.CLICK,closeThis);
		}
		private function onTaggleFullscreen(display:String):void  
		{
			if(stage.displayState == StageDisplayState.FULL_SCREEN){
				removeChild(playerCtrl);
				removeChild(playerskin);
				stage.addChild(playerCtrl);
				stage.addChild(playerskin);
				removeChild(closebutton);
				playerCtrl.setSize(stage.fullScreenWidth,stage.fullScreenHeight);
			}else{
				stage.removeChild(playerCtrl);
				stage.removeChild(playerskin);
				addChild(playerCtrl);
				addChild(playerskin);
				closebutton = new CloseButton();
				addChild(closebutton);
				closebutton.buttonMode = true;
				closebutton.addEventListener(MouseEvent.CLICK,closeThis);
				playerCtrl.setSize(1260,700);
			}
		}
		private function closeThis(e:MouseEvent):void
		{
			if(isYouTube){
				youtube.disconnect();
			}else{
				plns.disconnect();
			}
			commandMap.closeDialog();
		}
		override protected function get left():uint
		{
			return 0;
		}
		
		override protected function get top():uint
		{
			return 0;
		}
		
	}
}