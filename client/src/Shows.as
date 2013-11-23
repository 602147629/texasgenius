package
{
	public class Shows
	{
		public function Shows()
		{
		}
		
		public static function add(_string:String):void
		{
			trace(" ____"+_string);
		}
		
		public static function addByClass( _obj:Object , _string:String):void
		{
			trace(" ++++++++++++     [ "+_obj+" ]"+_string);
		}
	}
}