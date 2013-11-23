package com.sleepydesign.components.items
{
	import com.sleepydesign.core.IIDObject;
	import com.sleepydesign.display.SDSprite;

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class SDItemThumb extends SDSprite implements IIDObject
	{
		protected var _id:String;

		public function get id():String
		{
			return _id;
		}

		protected var _skin:DisplayObject;

		private var _culled:Boolean;

		public function get culled():Boolean
		{
			return _culled;
		}

		public function set culled(value:Boolean):void
		{
			if (_culled == value)
				return;

			_culled = value;

			visible = !_culled;
		}

		public function get pixelBounds():Rectangle
		{
			return transform.pixelBounds;
		}

		override public function destroy():void
		{
			_skin = null;

			super.destroy();
		}
	}
}
