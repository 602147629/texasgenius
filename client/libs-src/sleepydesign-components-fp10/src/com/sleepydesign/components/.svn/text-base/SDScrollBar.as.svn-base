package com.sleepydesign.components
{
	import com.sleepydesign.components.styles.SDSliderStyle;
	import com.sleepydesign.core.ITransformable;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	public class SDScrollBar extends SDSlider
	{
		private var _promissContentRect:Rectangle;

		public function get promissContentRect():Rectangle
		{
			return _promissContentRect;
		}

		public function set promissContentRect(value:Rectangle):void
		{
			_promissContentRect = value;
		}

		private var _scrollTarget:DisplayObject;
		public var lineScrollSize:Number = 10;

		public var enableHorizonWheel:Boolean;

		private var _useMouseWheel:Boolean = true;

		public function get useMouseWheel():Boolean
		{
			return _useMouseWheel;
		}

		public function set useMouseWheel(value:Boolean):void
		{
			_useMouseWheel = value;

			// Remove event
			//_scrollTarget.removeEventListener(TransformEvent.RESIZE, onResize);
			if (_scrollTarget is ITransformable)
				ITransformable(_scrollTarget).transformSignal.remove(onResize);

			_scrollTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

			// Add event
			if (value)
			{
				//_scrollTarget.addEventListener(TransformEvent.RESIZE, onResize, false, 0, true);
				if (_scrollTarget is ITransformable)
					ITransformable(_scrollTarget).transformSignal.add(onResize);

				_scrollTarget.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
				addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
			}
		}

		private function get _content():DisplayObject
		{
			try
			{
				return _scrollTarget["content"];
			}
			catch (e:*)
			{
				return _scrollTarget;
			}

			return _scrollTarget;
		}

		private function get _contentRect():Rectangle
		{
			return _promissContentRect || _content.getRect(_content.parent);
		}

		public function SDScrollBar(orientation:String = SDSliderStyle.VERTICAL, style:SDSliderStyle = null)
		{
			super(orientation, style);
		}

		override public function draw():void
		{
			if (!_scrollTarget || !_scrollTarget.scrollRect)
				return;

			if (_orientation == SDSliderStyle.HORIZONTAL)
			{
				// auto align
				//this.x = 0;
				//this.y = _scrollTarget.height;

				// auto size
				_scrollSize = Math.max(style.scroll_width, _width * _scrollTarget.scrollRect.width / _contentRect.width);
				setSize(_scrollTarget.scrollRect.width, style.scroll_width);

				// full bar -> disable?
				visible = style.hscroll_visible && (_scrollTarget.scrollRect.width < _contentRect.width);
			}
			else
			{
				// auto align
				//this.x = _scrollTarget.width;
				//this.y = 0;

				// auto size
				_scrollSize = Math.max(style.scroll_height, _height * _scrollTarget.scrollRect.height / _contentRect.height);
				setSize(style.scroll_width, _scrollTarget.scrollRect.height);

				// full bar -> disable?
				visible = style.vscroll_visible && (_scrollTarget.scrollRect.height < _contentRect.height);
			}

			// draw
			super.draw();
		}

		private var _cachedTransform:String;

		private function onResize(transform:Transform):void
		{
			if (_scrollTarget.transform.matrix.toString() == _cachedTransform)
				return;

			_cachedTransform = _scrollTarget.transform.matrix.toString();
			draw();
		}

		override public function set visible(value:Boolean):void
		{
			super.visible = value;
		}

		override public function get visible():Boolean
		{
			if (!_scrollTarget || !_scrollTarget.scrollRect)
				return false;

			if (_orientation == SDSliderStyle.HORIZONTAL)
				return style.hscroll_visible && Boolean(_scrollTarget.scrollRect.width < _contentRect.width);
			else
				return style.vscroll_visible && Boolean(_scrollTarget.scrollRect.height < _contentRect.height);
		}

		private function onWheel(event:MouseEvent):void
		{
			if (_orientation == SDSliderStyle.HORIZONTAL)
			{
				// not scroll content for HORIZONTAL if VERTICAL not exist
				if (event.currentTarget == this || enableHorizonWheel)
					scrollPosition -= int(event.delta * lineScrollSize);
			}
			else
			{
				scrollPosition -= int(event.delta * lineScrollSize);
			}
		}

		override protected function positionHandle():void
		{
			super.positionHandle();

			if (!_scrollTarget || !_scrollTarget.scrollRect)
				return;

			var gap:Number;

			if (_orientation == SDSliderStyle.HORIZONTAL)
			{
				gap = Math.max(0, _contentRect.width - _scrollTarget.scrollRect.width);
				_content.x = -_scrollPosition * gap / 100;
			}
			else
			{
				gap = Math.max(0, _contentRect.height - _scrollTarget.scrollRect.height);
				_content.y = -_scrollPosition * gap / 100;
			}
		}

		public function get scrollTarget():DisplayObject
		{
			return _scrollTarget;
		}

		public function set scrollTarget(value:DisplayObject):void
		{
			// Remove event
			//value.removeEventListener(TransformEvent.RESIZE, onResize);
			if (_scrollTarget is ITransformable)
				ITransformable(_scrollTarget).transformSignal.remove(onResize);

			value.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

			// Setup
			_scrollTarget = value;

			// auto align
			if (_orientation == SDSliderStyle.HORIZONTAL)
			{
				x = 0;
				y = _scrollTarget.height;
			}
			else
			{
				x = _scrollTarget.width;
				y = 0;
			}

			// View
			draw();

			// Add event
			if (_useMouseWheel)
			{
				//value.addEventListener(TransformEvent.RESIZE, onResize, false, 0, true);
				if (_scrollTarget is ITransformable)
					ITransformable(_scrollTarget).transformSignal.add(onResize);

				value.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
				addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
			}
		}

		public function get contentX():Number
		{
			return _content.x;
		}

		public function set contentX(value:Number):void
		{
			var gap:Number = Math.max(0, _contentRect.width - _scrollTarget.scrollRect.width);
			_scrollPosition = (gap != 0) ? (-value * 100 / gap) : 0;

			_slideChangeSignal.dispatch(scrollPercent);

			draw();
		}

		public function get contentY():Number
		{
			return _content.y;
		}

		public function set contentY(value:Number):void
		{
			var gap:Number = Math.max(0, _contentRect.height - _scrollTarget.scrollRect.height);
			_scrollPosition = (gap != 0) ? (-value * 100 / gap) : 0;

			_slideChangeSignal.dispatch(scrollPercent);

			draw();
		}
	}
}
