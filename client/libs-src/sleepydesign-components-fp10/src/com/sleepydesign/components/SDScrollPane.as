package com.sleepydesign.components
{
	import com.sleepydesign.components.styles.ISDStyle;
	import com.sleepydesign.components.styles.SDSliderStyle;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import org.osflash.signals.Signal;

	public class SDScrollPane extends SDComponent
	{
		public var panel:SDPanel;

		public var padding:uint = 0;

		private var _vScrollBar:SDScrollBar;

		public function get vScrollBar():SDScrollBar
		{
			return _vScrollBar;
		}

		private var _hScrollBar:SDScrollBar;

		public function get hScrollBar():SDScrollBar
		{
			return _hScrollBar;
		}

		private var _useMouseWheel:Boolean = true;

		public const slideCompleteSignal:Signal = new Signal;

		public function get useMouseWheel():Boolean
		{
			return _useMouseWheel;
		}

		public function set useMouseWheel(value:Boolean):void
		{
			_useMouseWheel = value;

			_vScrollBar.useMouseWheel = value;
			_hScrollBar.useMouseWheel = value;
		}

		public function get style():SDSliderStyle
		{
			return _style as SDSliderStyle;
		}

		public function set promissContentRect(value:Rectangle):void
		{
			_vScrollBar.promissContentRect = value;
			_hScrollBar.promissContentRect = value;
		}

		public function SDScrollPane(style:ISDStyle = null)
		{
			super(style);

			addChild(_back = new Shape);

			_vScrollBar = new SDScrollBar(SDSliderStyle.VERTICAL, this.style);
			addChild(_vScrollBar);

			_hScrollBar = new SDScrollBar(SDSliderStyle.HORIZONTAL, this.style);
			addChild(_hScrollBar);

			panel = new SDPanel(style);
			addChild(panel);
			target = panel;

			setSize(100, 100);
		}

		public function set target(value:SDPanel):void
		{
			_vScrollBar.scrollTarget = value;
			_hScrollBar.scrollTarget = value;

			draw();
		}

		public function redraw():void
		{
			target = panel;
		}

		public function addContent(child:DisplayObject):DisplayObject
		{
			panel.addChild(child);
			target = panel;
			return child;
		}

		public function removeContent(child:DisplayObject):DisplayObject
		{
			panel.removeChild(child);
			draw();
			return child;
		}

		override public function setSize(w:Number, h:Number):void
		{
			if (_width != w || _height != h)
			{
				_width = w;
				_height = h;

				panel.setSize(w, h);

				draw();
				transformSignal.dispatch(transform);
			}
		}

		public function scrollToPage(pageNum:int):void
		{
			var isDirty:Boolean = false;

			if (style.orientation == SDSliderStyle.HORIZONTAL)
			{
				var contentX:Number = -_hScrollBar.scrollTarget.scrollRect.width * pageNum;
				if (style.scrollTransition is Function)
				{
					style.scrollTransition(_hScrollBar, contentX, slideCompleteSignal.dispatch);
				}
				else
				{
					_hScrollBar.contentX = contentX;
					isDirty = true;
				}
			}
			else
			{
				var contentY:Number = -_vScrollBar.scrollTarget.scrollRect.height * pageNum;
				if (style.scrollTransition is Function)
				{
					style.scrollTransition(_vScrollBar, contentY, slideCompleteSignal.dispatch);
				}
				else
				{
					_vScrollBar.contentY = contentY;
					isDirty = true;
				}
			}
			
			if (isDirty)
				draw();
		}

		public function setPage(hPageTargetNum:int, vPageTargetNum:int = 0):void
		{
			var isDirty:Boolean = false;

			var contentX:Number = -_hScrollBar.scrollTarget.scrollRect.width * hPageTargetNum;
			if (_hScrollBar.contentX != contentX)
			{
				_hScrollBar.contentX = contentX;
				isDirty = true;
			}

			var contentY:Number = -_vScrollBar.scrollTarget.scrollRect.height * vPageTargetNum;
			if (_vScrollBar.contentY != contentY)
			{
				_vScrollBar.contentY = contentY;
				isDirty = true;
			}

			if (isDirty)
				draw();
		}

		public function get hPageNum():int
		{
			return getHPageNumFromWidth(_hScrollBar.scrollTarget.width);
		}

		public function get vPageNum():int
		{
			return getVPageNumFromHeight(_hScrollBar.scrollTarget.height);
		}

		public function getHPageNumFromWidth(value:Number):int
		{
			return Math.ceil(value / _hScrollBar.scrollTarget.scrollRect.width);
		}

		public function getVPageNumFromHeight(value:Number):int
		{
			return Math.ceil(value / _vScrollBar.scrollTarget.scrollRect.height);
		}

		override public function draw():void
		{
			_vScrollBar.draw();
			_hScrollBar.draw();

			_hScrollBar.enableHorizonWheel = !_vScrollBar.visible;

			_hScrollBar.enableHorizonWheel = _hScrollBar.enableHorizonWheel && useMouseWheel;

			drawBack(-padding / 2, -padding / 2, _vScrollBar.visible ? _vScrollBar.width + _width + padding : _width + padding, _hScrollBar.visible ? _hScrollBar.height + _height + padding : _height + padding, padding);

			super.draw();
		}
	}
}
