package module.roompage.roommodule
{
	import org.osflash.signals.Signal;

	public class RoomPageModel
	{
		public var searchString:String = "";
		public var signalUpdateRoom:Signal = new Signal();
		
		private static var canInit:Boolean = false;
		private static var instance:RoomPageModel;
		
		public function RoomPageModel()
		{
			if( !canInit ){
				throw new Error("Use get instance instead !!!");
			}
		}
		
		public static function getInstance():RoomPageModel
		{
			if( instance==null ){
				canInit = true;
				instance = new RoomPageModel();
				canInit = false;
			}
			return instance;
		}
	}
}