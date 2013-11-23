package EXIT.debugger 
{
	import flash.utils.getTimer;

	public class Debug
	{
		private static var time:Number = 0;
		public function Debug()
		{
		}
		
		public static function startTime():void
		{
			time = getTimer();
		}
		
		public static function endTime():void
		{
			var tempTime:Number = getTimer();
			trace(tempTime-time,' ms.');
			time = getTimer();
		}
	}
}