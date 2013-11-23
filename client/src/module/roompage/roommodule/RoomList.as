package module.roompage.roommodule
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	public class RoomList extends roomjoin
	{
		public var _id:Number;
		public var _name:String;
		public var signalSelected:Signal = new Signal(RoomList);
		
		private var _isSelected:Boolean = false;
		
		public function RoomList(_id:Number,_name:String,_players:Number,_maxPlayer:Number)
		{
			super();
			buttonMode=true;
			this._id = _id;
			this._name = _name;
			update(_id,_name,_players,_maxPlayer);
			
			
			addEventListener(MouseEvent.CLICK , onChoose );
			addEventListener(Event.REMOVED_FROM_STAGE , removed );
		}
		
		public function select():void
		{
			_isSelected = true;
			this.alpha = .5;
		}
		
		public function deSelect():void
		{
			_isSelected = false;
			this.alpha = 1;
		}
		
		protected function onChoose(event:MouseEvent):void
		{
			signalSelected.dispatch(this);
			//ServerConnector.getInstace().join(_id);
		}
		
		public function update(_id:Number,_name:String,_players:Number,_maxPlayer:Number):void
		{
			roomId.text = String(_id);
			roomName.text = _name;
			sbbb
			numuser.text = _players+"/"+_maxPlayer;
			lastbuy
			sumbuy
		}
		
		protected function removed(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
	}
}