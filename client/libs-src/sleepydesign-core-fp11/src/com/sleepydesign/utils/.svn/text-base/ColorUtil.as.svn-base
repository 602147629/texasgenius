package com.sleepydesign.utils
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ColorUtil
	{
		public static function getARGB(color:uint):Object
		{
			var c:Object = {};
			c.a = color >> 24 & 0xFF;
			c.r = color >> 16 & 0xFF;
			c.g = color >> 8 & 0xFF;
			c.b = color & 0xFF;

			return c;
		}

		public static function replaceColor(bitmapData:BitmapData, color:uint, replaceColor:uint):void
		{
			bitmapData.threshold(bitmapData, bitmapData.rect, new Point(0, 0), "==", color, replaceColor, 0xFFFFFFFF, false);
		}

		public static function removeColor(bitmapData:BitmapData, color:uint, glowColor:uint):void
		{
			bitmapData.threshold(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), new Point(0, 0), "==", color, 0x00000000, 0xFFFFFFFF, false);

			if (glowColor > 0)
				bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), new GlowFilter(glowColor, 300, 6, 6, 1.8, 3, true, false));
		}
	}
}
