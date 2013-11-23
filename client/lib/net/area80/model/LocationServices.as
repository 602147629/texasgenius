package net.area80.model
{

	import flash.events.EventDispatcher;
	import flash.events.GeolocationEvent;
	import flash.events.StatusEvent;
	import flash.sensors.Geolocation;

	import org.osflash.signals.Signal;

	public class LocationServices
	{
		public static var geo:Geolocation;
		public static var SIGNAL_LOCATIONCHANGE:Signal = new Signal();

		private static var _lat:Number = 0;
		private static var _lng:Number = 0;
		private static var _alt:Number = 0;
		private static var _accuracy:Number = 0;

		private static var _muted:Boolean = true;
		private static var _support:Boolean = false;
		private static var _isInit:Boolean = false;
		private static var _isConnected:Boolean = false;

		public static function isConnected():Boolean
		{
			return _isConnected;
		}

		public static function getLat():Number
		{
			return _lat;
		}

		public static function getLng():Number
		{
			return _lng;
		}

		public static function getAltitude():Number
		{
			return _alt;
		}

		public static function muted():Boolean
		{
			return _muted;
		}

		public static function support():Boolean
		{
			return _support;
		}

		public static function hasLatlng():Boolean
		{
			return (_lat==0||_lng==0);
		}

		public static function initGeolocation():void
		{
			if (!_isInit) {
				if (Geolocation.isSupported) {
					_support = true;
					geo = new Geolocation();


					geo.addEventListener(StatusEvent.STATUS, onStatus);
					geo.addEventListener(GeolocationEvent.UPDATE, onGeoUpdate);
//					geo.setRequestedUpdateInterval(10000);

				} else {
					_support = false;
				}
				_isInit = true;
			}
		}

		protected static function onGeoUpdate(event:GeolocationEvent):void
		{
			if (!_isConnected) {
				geo.setRequestedUpdateInterval(10000);
			}
			_lat = event.latitude;
			_lng = event.longitude;
			_accuracy = event.horizontalAccuracy;
			_alt = event.altitude;

			_isConnected = true;
			SIGNAL_LOCATIONCHANGE.dispatch();
		}


		protected static function onStatus(event:StatusEvent):void
		{
			if (geo.muted) {
				_muted = true;
			} else {
				_muted = false;
			}
		}
	}
}
