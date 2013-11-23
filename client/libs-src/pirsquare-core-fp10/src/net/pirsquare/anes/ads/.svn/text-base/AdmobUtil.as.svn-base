package net.pirsquare.anes.ads
{

	import com.devilishgames.air.extensions.admob.ios.AdMob;

	import flash.display.Stage;
	import flash.geom.Point;

	import net.pirsquare.m.DeviceUtil;


	/**
	 * TODO : test activated/deactivated
	 *
	 * @author katopz
	 *
	 */
	public class AdmobUtil
	{
		private static var _isInit:Boolean = false;
		private static var _isShow:Boolean = false;

		private static var _adMob:AdMob;

		private static var _deviceType:String;

		public static var ALIGN_TOP:String = "TOP";
		public static var ALIGN_BOTTOM:String = "BOTTOM";

		private static var _alignment:String = ALIGN_BOTTOM;

		public static function get adSize():Point
		{
			return _adSize;
		}

		public static function get alignment():String
		{
			return _alignment;
		}

		private static var _adPoint:Point;
		private static var _adSize:Point;

		public static function set alignment(value:String):void
		{
			_alignment = value ? value : _alignment;

			_adPoint = new Point();
			_adSize = new Point();

			switch (_deviceType)
			{
				case DeviceUtil.TYPE_IPHONE_3GS:
				{
					_adPoint.x = 960 * .5 * .5 - 320 * .5;
					_adPoint.y = 640 * .5 - 50;
					_adSize = AdMob.GAD_SIZE_320x50;
					break;
				}
				case DeviceUtil.TYPE_IPHONE_4:
				case DeviceUtil.TYPE_IPHONE_4S:
				{
					_adPoint.x = 960 * .5 * .5 - 320 * .5;
					_adPoint.y = 640 * .5 - 50;
					_adSize = AdMob.GAD_SIZE_320x50;
					break;
				}
				case DeviceUtil.TYPE_IPAD_1:
				case DeviceUtil.TYPE_IPAD_2:
				{
					/*_adPoint.x = 1024 * .5 - 468 * .5;
					_adPoint.y = 768 - 60;
					_adSize = AdMob.GAD_SIZE_468x60;*/
					_adPoint.x = 1024 * .5 - 728 * .5;
					_adPoint.y = 768 - 90;
					_adSize = AdMob.GAD_SIZE_728x90;
					break;
				}
				case DeviceUtil.TYPE_IPAD_3:
				{
					/*_adPoint.x = 1024 * .5 - 468 * .5;
					_adPoint.y = 768 - 60;
					_adSize = AdMob.GAD_SIZE_468x60;*/
					_adPoint.x = 1024 * .5 - 728 * .5;
					_adPoint.y = 768 - 90;
					_adSize = AdMob.GAD_SIZE_728x90;
					break;
				}
				default:
				{
					_adPoint.x = 960 * .5 * .5 - 320 * .5;
					_adPoint.y = 640 * .5 - 50;
					_adSize = AdMob.GAD_SIZE_320x50;
					break;
				}
			}

			if (_alignment == ALIGN_TOP)
				_adPoint.y = 0;

			if (_adMob)
			{
				_adMob.position.y = _adPoint.y;
				trace(" ! _adMob.position : " + _adMob.position);
			}
		}

		public static function autoSizeInit(deviceType:String, admobID:String, admobAlignment:String = null, testMode:Boolean = false, stage:Stage = null):void
		{
			_deviceType = deviceType;
			alignment = admobAlignment ? admobAlignment : ALIGN_BOTTOM;

			init(admobID, _adPoint, _adSize, testMode, stage);
		}

		public static function autoSizeInitAndShow(deviceType:String, admobID:String, admobAlignment:String = null, testMode:Boolean = false, stage:Stage = null):void
		{
			_deviceType = deviceType;
			alignment = admobAlignment;

			initAndShow(admobID, _adPoint, _adSize, testMode, stage);
		}

		public static function initAndShow(admobID:String, adPoint:Point, adSize:Point = null, testMode:Boolean = false, stage:Stage = null):void
		{
			init(admobID, adPoint, adSize, testMode, stage);
			show();
		}

		public static function init(admobID:String, adPoint:Point, adSize:Point = null, testMode:Boolean = false, stage:Stage = null):void
		{
			trace(" ! init : " + admobID, adPoint, testMode, _isInit);

			if (_isInit)
			{
				trace(" ! already init");
				return;
			}

			_isInit = true;

			_adMob = new AdMob();
			_adMob.id = admobID;
			_adMob.size = adSize ? adSize : AdMob.GAD_SIZE_468x60;
			_adMob.position = adPoint;
			_adMob.testMode = testMode;

			// in case manual set
			_adPoint = _adMob.position;
			_adSize = _adMob.size;
		}

		public static function show(admobAlignment:String = null):void
		{
			if (_isShow)
				return;

			_isShow = true;

			trace(" * show admob");

			if (!_isInit)
				throw new Error("[Error] Must init first");

			alignment = admobAlignment;

			if (DeviceUtil.isAIRDesktop)
				return;

			_adMob.size = adSize ? adSize : AdMob.GAD_SIZE_468x60;
			_adMob.showAdMob();
		}

		public static function hide():void
		{
			if (!_isShow)
				return;

			_isShow = false;

			trace(" * hide admob");

			if (!_isInit)
				return;

			if (DeviceUtil.isAIRDesktop)
				return;

			_adMob.hideAdMob();
		}
	}
}
