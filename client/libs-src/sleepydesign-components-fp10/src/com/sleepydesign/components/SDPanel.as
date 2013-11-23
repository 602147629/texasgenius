package com.sleepydesign.components
{
	import com.sleepydesign.components.styles.ISDStyle;
	import com.sleepydesign.components.styles.SDSliderStyle;

	import flash.display.DisplayObject;
	import flash.display.Shape;

	public class SDPanel extends SDComponent
	{
		public var content:DisplayObject;

		public function get style():SDSliderStyle
		{
			return _style as SDSliderStyle;
		}

		public function SDPanel(style:ISDStyle = null)
		{
			super(style);

			addChild(_back = new Shape);

			setSize(100, 100);
			scrollRect = _back.getRect(_back.parent);
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			content = child;
			return super.addChild(content);
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(content);
		}

		override public function draw():void
		{
			drawBack(0, 0, _width, _height);

			scrollRect = _back.getRect(_back.parent);
			//scrollRect.width += _style.BORDER_THICK;
			//scrollRect.height += _style.BORDER_THICK;

			super.draw();
		}
	}
}
