package com.sleepydesign.utils
{

	public class ConversionUtil
	{
		private static const _LEVELS:Array = ['bytes', 'Kb', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

		public static function bytesToString(bytes:Number):String
		{
			var index:uint = Math.floor(Math.log(bytes) / Math.log(1024));
			return (bytes / Math.pow(1024, index)).toFixed(2) + " " + _LEVELS[index];
		}

	}
}
