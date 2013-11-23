package  net.pirsquare.m
{
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.scanHardware;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	public class DeviceUtil
	{
		// referrence, TODo : add more device eg. android

		// init ------------------------------------------------------------------------------

		public static const TYPE_IPAD_1:String = "iPad1";
		public static const TYPE_IPAD_2:String = "iPad2";
		public static const TYPE_IPAD_3:String = "iPad3";
		public static const TYPE_IPHONE_3GS:String = "iPhone2";
		public static const TYPE_IPHONE_4:String = "iPhone3";
		public static const TYPE_IPHONE_4S:String = "iPhone4";

		public static const _resolutionDic:Dictionary = new Dictionary();

		private static var _isInit:Boolean = false;

		/*private static function init():void
		{
			if (_isInit)
				return;

			_resolutionDic[TYPE_IPAD_1] = new Point(768, 1024);
			_resolutionDic[TYPE_IPAD_2] = new Point(768, 1024);
			_resolutionDic[TYPE_IPAD_3] = new Point(1536, 2048);
			_resolutionDic[TYPE_IPHONE_3GS] = new Point(320, 480);
			_resolutionDic[TYPE_IPHONE_4] = new Point(640, 960);
			_resolutionDic[TYPE_IPHONE_4S] = new Point(640, 960);

			_isInit = true;
		}*/

		// useful method go here ------------------------------------------------------------------------------
		
		/**
		 * Check whether user is on mobile device ot not
		 * @return true if on mobile device 
		 * 
		 */
		public static function get isAIRCaptiveAppMobile():Boolean
		{
			// Android or iPhone or iPad
			return (Capabilities.os.indexOf("Linux") == 0) || (Capabilities.os.indexOf("iPhone") == 0) || (Capabilities.os.indexOf("iPad") == 0);
		}
		
		/**
		 * Check whether user is on desktop ot not
		 * @return true if on desktop
		 * 
		 */
		public static function get isAIRDesktop():Boolean
		{
			const os:String = Capabilities.os.split(" ")[0];
			return (Capabilities.playerType == "Desktop") && ((os == "Windows") || (os == "Mac"));
		}

		/**
		 *
		 * @return Device type for present device.
		 *
		 */
		public static function get deviceType():String
		{

			var datas:Array = Capabilities.os.split(" ");

			var type:String = datas[datas.length - 1].split(",")[0];
			return type;
		}

		public static function get platform():String
		{
			var datas:Array = Capabilities.os.split(" ");

			var platform:String = datas[0];
			return platform;
		}

		/**
		 * @return Camera amount in present device.
		 */
		public static function get totalCameras():int
		{
			if (!Camera.isSupported)
				return 0;

			var cameras:Array = [];
			for (var i:uint = 0; i < Camera.names.length; ++i)
				cameras.push(Camera.getCamera(String(i)));
			return cameras.length;
		}

		/**
		 * @return Capabilities.cpuArchitecture in present device.
		 */
		public static function get screenDPI():int
		{
			return Capabilities.screenDPI;
		}

		/**
		 * @return Capabilities.cpuArchitecture in present device.
		 */
		public static function get cpuArchitecture():String
		{
			return Capabilities.cpuArchitecture;
		}

		/**
		 * @return Capabilities.screenResolutionX in present device.
		 */
		public static function get screenResolutionX():int
		{
			return Capabilities.screenResolutionX;
		}

		/**
		 * @return Capabilities.screenResolutionY in present device.
		 */
		public static function get screenResolutionY():int
		{
			return Capabilities.screenResolutionY;
		}

		/**
		 * @return Capabilities.screenResolutionY in present device.
		 */
		public static function get deviceInfo():XML
		{
			return describeType(Capabilities);
		}


	}
}
