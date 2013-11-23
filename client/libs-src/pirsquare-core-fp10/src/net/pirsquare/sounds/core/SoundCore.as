package net.pirsquare.sounds.core
{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	/**
	 *
	 * @author O
	 *
	 */

	public class SoundCore
	{

		public static const LEFT:Number = -1;
		public static const RIGHT:Number = 1;
		public static const CENTER:Number = 0;

		private static var _currentUid:int = 0;
		private static var _manager:SoundManager;

		private static const EXT_RE:RegExp = /\.(\w+)$/;

		public function SoundCore()
		{
			throw new Error("Core : this class shouldnt't be instanciated");
		}

		public static function get manager():SoundManager
		{
			if (!_manager)
				createManager();

			return _manager;
		}

		private static function createManager():void
		{
			_manager = SoundManager.getInstance(SoundCore);
			_manager.initialize();
		}

		public static function getUid():int
		{
			return _currentUid++;
		}

		public static function getTime(t:Number, totalLength:Number):Number
		{
			if (t < 0)
				throw(new Error("Invalid time format (time < 0)"));
			return (t < 1) ? t * totalLength : t;
		}

		public static function getFileExt(_url:String):String
		{
			return (EXT_RE.exec(_url)[1]).toLowerCase();
		}

		public static function cookieWrite(cookieId:String, p:Object):Boolean
		{
			var so:SharedObject = SharedObject.getLocal(cookieId);
			for (var i:String in p)
			{
				so.data[i] = p[i];
			}

			return (so.flush(500) == SharedObjectFlushStatus.FLUSHED);
		}

		public static function cookieRetrieve(cookieId:String):Object
		{
			var so:SharedObject = SharedObject.getLocal(cookieId);
			return so.data;
		}
	}

}

