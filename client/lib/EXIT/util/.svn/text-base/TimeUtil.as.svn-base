package EXIT.util
{
	public class TimeUtil
	{
		public function TimeUtil()
		{
		}
		
		public static function getTimeFormatBySec( time:Number ):String
		{
			time = Math.floor(time);
			var sec:Number = time%60;
			var minute:Number = Math.floor( (time%3600) /60 );
			var hour:Number = Math.floor( time/3600 );
			return addZero(hour)+":"+addZero(minute)+":"+addZero(sec);
		}
		private static function addZero( num:Number ):String
		{
			var str:String;
			if(num<10)
				return "0"+num;
			else
				return String(num);
		}
	}
}