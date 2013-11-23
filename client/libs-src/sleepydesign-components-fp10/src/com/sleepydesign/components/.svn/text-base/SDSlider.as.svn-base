package com.sleepydesign.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.sleepydesign.components.styles.SDSliderStyle;
	import com.sleepydesign.display.SDSprite;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import org.osflash.signals.Signal;

	public class SDSlider extends SDComponent
	{
		protected var _handle:Sprite;
		protected var _track:Sprite;

		protected var _scrollPosition:Number = 0;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _orientation:String;

		protected var _scrollSize:Number;
		protected var _pageSize:Number = 0;
		protected var _lastPosition:Point;

		// signals --------------------------------------------------

		protected const _slideChangeSignal:Signal = new Signal(Number);

		protected var _scrollPositionAni:Number;

		public function get slideChangeSignal():Signal
		{
			return _slideChangeSignal;
		}

		// style --------------------------------------------------

		public function get style():SDSliderStyle
		{
			return _style as SDSliderStyle;
		}

		public function SDSlider(orientation:String = "", style:SDSliderStyle = null)
		{
			if (orientation == "")
				orientation = SDSliderStyle.HORIZONTAL;
			super(style);

			_scrollSize = style.scroll_width;

			_orientation = orientation;

			_track = new SDSprite();
			addChild(_track);

			_handle = new SDSprite();
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
			_handle.buttonMode = false;
			_handle.useHandCursor = false;
			addChild(_handle);

		/*
		   if (_orientation == HORIZONTAL)
		   setSize(100, _scrollSize);
		   else
		   setSize(_scrollSize, 100);
		 */
		}

		protected function drawTrack():void
		{
			_track.graphics.clear();
			_track.graphics.lineStyle(); //.25, 0x000000, 1);
			_track.graphics.beginFill(0x000000, .5);
			_track.graphics.drawRect(0, 0, _width, _height);
			_track.graphics.endFill();

			_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackClick);
			_track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackClick, false, 0, true);
		}

		protected function drawHandle(size:Number = 0):void
		{
			if (isNaN(size))
				return;

			_handle.graphics.clear();
			_scrollSize = size;

			_handle.graphics.lineStyle(); //_style.BORDER_THICK, _style.BORDER_COLOR, _style.BORDER_ALPHA);
			_handle.graphics.beginFill(0xFFFFFF);

			if (_orientation == SDSliderStyle.HORIZONTAL)
				_handle.graphics.drawRect(0, 0, _scrollSize, _height);
			else
				_handle.graphics.drawRect(0, 0, _width, _scrollSize);

			_handle.graphics.endFill();

			positionHandle();
		}

		protected function correctValue():void
		{
			if (!style.useBoundBounce)
			{
				if (_max > _min)
				{
					_scrollPosition = Math.min(_scrollPosition, _max);
					_scrollPosition = Math.max(_scrollPosition, _min);
				}
				else
				{
					_scrollPosition = Math.max(_scrollPosition, _max);
					_scrollPosition = Math.min(_scrollPosition, _min);
				}
			}
			else
			{
				if (_max > _min)
				{
					_scrollPositionAni = Math.min(_scrollPosition, _max);
					_scrollPositionAni = Math.max(_scrollPositionAni, _min);
				}
				else
				{
					_scrollPositionAni = Math.max(_scrollPosition, _max);
					_scrollPositionAni = Math.min(_scrollPositionAni, _min);
				}
			}
		}

		protected function positionHandle():void
		{
			if (_orientation == SDSliderStyle.HORIZONTAL)
			{
				_handle.x = Math.min(_scrollPosition * (_width - _handle.width) / (_max - _min), (_width - _handle.width));
				_handle.x = Math.max(_handle.x, 0);
			}
			else
			{
				_handle.y = Math.min(_scrollPosition * (_height - _handle.height) / (_max - _min), (_height - _handle.height));
				_handle.y = Math.max(_handle.y, 0);
			}
		}

		override public function draw():void
		{
			drawTrack();
			drawHandle(_scrollSize);
			//super.draw();
		}

		public function setSliderParams(min:Number, max:Number, scrollPosition:Number, pageSize:Number = 10):void
		{
			this.minimum = min;
			this.maximum = max;
			this.scrollPosition = scrollPosition;
			this.pageSize = pageSize;
		}

		protected function onTrackClick(event:MouseEvent):void
		{
			var oldScrollPosition:Number = _scrollPosition;
			if (_orientation == SDSliderStyle.HORIZONTAL)
			{
				_handle.x = Math.max(mouseX - _handle.width * .5, 0);
				_handle.x = Math.min(_handle.x, width - _handle.width);
				_scrollPosition = _handle.x * (_max - _min) / (_width - _handle.width);
			}
			else
			{
				_handle.y = Math.max(mouseY - _handle.height * .5, 0);
				_handle.y = Math.min(_handle.y, height - _handle.height);
				_scrollPosition = _handle.y * (_max - _min) / (_height - _handle.height);
			}

			positionHandle();

			if (_scrollPosition != oldScrollPosition)
				_slideChangeSignal.dispatch(scrollPercent);
		}

		override protected function onDrag(event:MouseEvent):void
		{
			//click some where on _handle
			_lastPosition = new Point(DisplayObject(event.target).mouseX, DisplayObject(event.target).mouseY);

			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide, false, 0, true);
		}

		override protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			stopDrag();
		}

		protected function onSlide(event:MouseEvent):void
		{
			var pt:Point = new Point(event.localX, event.localY);
			pt = event.target.localToGlobal(pt);
			pt = globalToLocal(pt);

			var oldScrollPosition:Number = _scrollPosition;
			if (_orientation == SDSliderStyle.HORIZONTAL)
			{
				_handle.x = Math.min(pt.x - _lastPosition.x * _handle.scaleX, _width - _handle.width);
				_handle.x = Math.max(_handle.x, 0);

				_scrollPosition = _handle.x * (_max - _min) / (_width - _handle.width);
			}
			else
			{
				_handle.y = Math.min(pt.y - _lastPosition.y, _height - _handle.height);
				_handle.y = Math.max(_handle.y, 0);

				_scrollPosition = _handle.y * (_max - _min) / (_height - _handle.height);
			}

			positionHandle();

			if (_scrollPosition != oldScrollPosition)
				_slideChangeSignal.dispatch(scrollPercent);
		}

		public function set scrollPosition(value:Number):void
		{
			if (_scrollPosition == value)
				return;

			_scrollPosition = value;
			correctValue();
			positionHandle();

			_slideChangeSignal.dispatch(scrollPercent);
		}

		public function get scrollPosition():Number
		{
			return _scrollPosition;
		}

		public function set scrollPercent(value:Number):void
		{
			_scrollPosition = _max * value;
			correctValue();
			positionHandle();

			_slideChangeSignal.dispatch(scrollPercent);
		}

		public function get scrollPercent():Number
		{
			return _scrollPosition / _max;
		}

		public function restoreScrollPosition(pos:Number, onComplete:Function = null):void
		{
			/*
			if (isNaN(_scrollPositionAni))
				return;

			if (_scrollPositionAni == scrollPosition)
			{
				if (onComplete is Function)
					onComplete();

				return;
			}

			if (style.useBoundBounce)
			{
				TweenLite.to(this, .25, {scrollPosition: _scrollPositionAni, ease: Quad.easeOut, onComplete: onComplete});
			}
			else
			{
				if (onComplete is Function)
					onComplete();
			}
			*/

			if (onComplete is Function)
				TweenLite.to(this, .25, {contentY: pos, ease: Quad.easeOut, onComplete: onComplete});
			else
				TweenLite.to(this, .25, {contentY: pos, ease: Quad.easeOut});
		}

		public function cancelAniScrollPosition():void
		{
			TweenLite.killTweensOf(this);
		}

		public function set maximum(value:Number):void
		{
			_max = value;
			correctValue();
			positionHandle();
		}

		public function get maximum():Number
		{
			return _max;
		}

		public function set minimum(m:Number):void
		{
			_min = m;
			correctValue();
			positionHandle();
		}

		public function get minimum():Number
		{
			return _min;
		}

		public function set pageSize(value:Number):void
		{
			_scrollPosition = value + _pageSize;
			correctValue();
			positionHandle();

			_slideChangeSignal.dispatch(scrollPercent);
		}

		public function get pageSize():Number
		{
			return _pageSize;
		}
	}
}
