package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import model.MainModel;
	
	import module.IPage;
	import module.gamepage.GamePage;
	import module.roompage.RoomPage;
	
	import net.area80.utils.DrawingUtils;
	
	public class main extends Sprite
	{
		private var mainModel:MainModel = MainModel.getInstance();
		private var currentPageSprite:IPage;
		private var freezeMc:Sprite = DrawingUtils.getRectSprite(500,500,0);
		
		private var pageLayer:Sprite = new Sprite();
		private var freezeLayer:Sprite = new Sprite();
		
		public function main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			var obj:Object = root.loaderInfo.parameters;
			if( obj!=null ){
				UserData.access_token = obj.access_token;
				UserData.fbuid = obj.fbuid;
			}
			trace("access_token:"+UserData.access_token);
			trace("uid:"+UserData.fbuid);
			
			addChild(pageLayer);
			addChild(freezeLayer);
			
			mainModel.addChangePageCallback(changePage);
			mainModel.addFreezeCallback(freezeCallback);
			mainModel.changePage(MainModel.PAGE_ROOM);
			
			freezeMc.alpha = .5;
		}
		
		private function changePage(_page:String):void
		{
			if(currentPageSprite){
				currentPageSprite.dispose();
				pageLayer.removeChild(Sprite(currentPageSprite));
			}
			if( _page == MainModel.PAGE_ROOM ){
				currentPageSprite = new RoomPage();
				currentPageSprite.start();
				pageLayer.addChild( Sprite(currentPageSprite) );
			}else if( _page == MainModel.PAGE_GAME ){
				currentPageSprite = new GamePage();
				currentPageSprite.start();
				pageLayer.addChild( Sprite(currentPageSprite) );
			}
		}
		
		private function freezeCallback(_isFreeze:Boolean):void
		{
			if( _isFreeze ){
				this.mouseEnabled = false;
				this.mouseChildren = false;
				freezeMc.width = stage.stageWidth;
				freezeMc.height = stage.stageHeight;
				freezeLayer.addChild(freezeMc);
			}else{
				this.mouseEnabled = true;
				this.mouseChildren = true;
				if( freezeLayer.contains(freezeMc) ){
					freezeLayer.removeChild(freezeMc);
				}
			}
		}
	}
}