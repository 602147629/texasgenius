package com.sleepydesign.components.styles
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.sleepydesign.components.SDScrollBar;

	public class SDSliderStyle extends SDStyle implements ISDStyle
	{
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";

		protected var _orientation:String = SDSliderStyle.HORIZONTAL;

		public function set orientation(value:String):void
		{
			_orientation = value;
		}

		public function get orientation():String
		{
			return _orientation;
		}

		public var scrollTransition:Function = function(scrollBar:SDScrollBar, contentXY:Number, callback:Function):void
		{
			TweenLite.killTweensOf(scrollBar);
			if (_orientation == HORIZONTAL)
			{
				TweenLite.to(scrollBar, 0.25, {contentX: contentXY, ease: Quad.easeOut, onComplete: callback});
			}
			else
			{
				TweenLite.to(scrollBar, 0.25, {contentY: contentXY, ease: Quad.easeOut, onComplete: callback});
			}
		}

		public function get scroll_width():Number
		{
			return 10;
		}

		public function get scroll_height():Number
		{
			return 10;
		}

		public function get vscroll_visible():Boolean
		{
			return true;
		}

		public function get hscroll_visible():Boolean
		{
			return true;
		}

		public var useBoundBounce:Boolean = false;
	}
}
