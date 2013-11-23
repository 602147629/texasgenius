package module.roompage.roommodule
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CreateRoomPopup extends createRoomPopup
	{
		private var onOkFunction:Function;
		public function CreateRoomPopup(_onOkFunction:Function)
		{
			super();
			onOkFunction = _onOkFunction;
			okBtn.addEventListener(MouseEvent.CLICK, onOk );
			cancelBtn.addEventListener(MouseEvent.CLICK, onCancel );
			x = 760*.5;
			y = 1200*.5;
		}
		
		protected function onOk(event:MouseEvent):void
		{
			onOkFunction(roomNameText.text);
			onCancel();
		}
		
		protected function onCancel(event:MouseEvent=null):void
		{
			parent.removeChild(this);
		}
	}
}