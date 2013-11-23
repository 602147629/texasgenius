package com.sleepydesign.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MathUtil
	{
		public static function getPointFromIndex(index:int, size:uint):Point
		{
			return new Point(int(index % size), int(index / size));
		}

		public static function getRectFromIndex(index:int, size:uint, width:uint, height:uint, gapX:uint = 0, gapY:uint = 0):Rectangle
		{
			var point:Point = getPointFromIndex(index, width);
			// add gap
			point.offset(gapX, gapY);

			return new Rectangle(point.x, point.y, width, height);
		}


		/**
		 * Use for texture auto w/h as next power of 2
		 *
		 * @param v
		 * @return next power of 2
		 *
		 */
		public static function nextPowerOfTwo(v:uint):uint
		{
			v--;
			v |= v >> 1;
			v |= v >> 2;
			v |= v >> 4;
			v |= v >> 8;
			v |= v >> 16;
			v++;
			return v;
		}
	}
}
