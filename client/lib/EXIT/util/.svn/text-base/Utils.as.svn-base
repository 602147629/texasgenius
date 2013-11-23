package EXIT.util
{
	import flash.utils.ByteArray;

	public class Utils
	{
		public function Utils()
		{
		}

		public static function clone(_source:*):*
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(_source);
			byteArray.position = 0;
			return byteArray.readObject();
		}
	}
}
