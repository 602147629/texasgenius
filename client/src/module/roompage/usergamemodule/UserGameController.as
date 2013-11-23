package module.roompage.usergamemodule
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class UserGameController
	{

		private var gangBtn:Sprite;
		private var socialBtn:Sprite;
		private var gangContainer:Sprite;
		private var socialContainer:Sprite;
		
		private var gangController:PeopleController;
		private var socialController:PeopleController;
		
		private var currentBtn:* = gangBtn;
		public function UserGameController(_gangBtn:Sprite,_socialBtn:Sprite,_gangContainer:Sprite,_socialContainer:Sprite)
		{
			gangBtn = _gangBtn;
			socialBtn = _socialBtn;
			gangContainer = _gangContainer;
			socialContainer = _socialContainer;
			
			gangController = new PeopleController(gangContainer);
			gangController.enable();
			socialController = new PeopleController(socialContainer);
			socialController.disable();
			
			gangBtn.addEventListener(MouseEvent.CLICK , changeType);
			socialBtn.addEventListener(MouseEvent.CLICK , changeType);
		}
		
		protected function changeType(event:MouseEvent):void
		{
			if( event.currentTarget != currentBtn ){
				currentBtn = event.currentTarget;
				if( currentBtn == gangBtn ){
					gangController.enable();
					socialController.disable();
				}else{
					socialController.enable();
					gangController.disable();
				}
			}
		}
	}
}