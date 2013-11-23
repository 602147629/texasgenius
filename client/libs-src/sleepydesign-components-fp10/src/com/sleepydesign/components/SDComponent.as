package com.sleepydesign.components
{
	import com.sleepydesign.components.styles.ISDStyle;
	import com.sleepydesign.components.styles.SDStyle;
	import com.sleepydesign.core.ITransformable;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.utils.AlignUtil;
	
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	import org.osflash.signals.Signal;

	public class SDComponent extends SDSprite implements ITransformable
	{
		protected var _width:Number = 0;
		protected var _height:Number = 0;

		protected var _style:ISDStyle = new SDStyle;

		private var _transformSignal:Signal = new Signal(Transform);

		public function get transformSignal():Signal
		{
			return _transformSignal;
		}

		protected var _back:Shape;

		public function get pixelBounds():Rectangle
		{
			return _back.transform.pixelBounds;
		}

		protected var _enabled:Boolean;

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;

			_enabled = value;

			mouseEnabled = mouseChildren = _enabled;
			alpha = _enabled ? 1 : .5;
		}

		public function SDComponent(style:ISDStyle = null)
		{
			_style = style ? style : _style;

			addChild(_back = new Shape);
		}

		public function drawBack(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number = 0, ellipseHeight:Number = 0):void
		{
			_back.graphics.clear();
			_back.graphics.lineStyle();

			if (_style.border_width > 0 && _style.border_color > 0 && _style.border_alpha > 0)
				_back.graphics.lineStyle(_style.border_width, _style.border_color, _style.border_alpha, true, LineScaleMode.NONE);

			if (_style.background_alpha > 0)
				_back.graphics.beginFill(_style.background_color, _style.background_alpha);

			if (_style.background_alpha == 0 && _style.border_alpha)
				_back.visible = false;

			_back.graphics.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
			_back.graphics.endFill();
		}

		public function draw():void
		{
			// draw back
			drawBack(0, 0, _width, _height);

			// auto align
			autoAlign();
		}

		protected function autoAlign():void
		{
			if (!_align)
				return;

			// align
			if (stage)
			{
				AlignUtil.alignToStage(_align, this);
					// TODO : custom align AlignUtil.align(_align, this, _parent);
			}
		}

		protected var _align:String;

		public function get align():String
		{
			return _align;
		}

		public function set align(value:String):void
		{
			_align = value;

			if (!stage)
			{
				if (hasEventListener(Event.ADDED_TO_STAGE))
					removeEventListener(Event.ADDED_TO_STAGE, onStage);
				addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
				return;
			}
			else
			{
				draw();
			}
		}

		private function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			draw();
		}

		// Transform ------------------------------------------------------------------------

		public function setPosition(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}

		public function setSize(w:Number, h:Number):void
		{
			var isDirty:Boolean = false;
			if (_width != w)
			{
				_width = w;
				isDirty = true;
			}

			if (_height != h)
			{
				_height = h;
				isDirty = true;
			}

			if (!isDirty)
				return;

			draw();
			transformSignal.dispatch(transform);
		}

		override public function set width(w:Number):void
		{
			if (_width == w)
				return;

			_width = w;
			draw();
			transformSignal.dispatch(transform);
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set height(h:Number):void
		{
			if (_height == h)
				return;

			_height = h;
			draw();
			transformSignal.dispatch(transform);
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set x(value:Number):void
		{
			if (x == value)
				return;

			super.x = value;
			// TODO : position invalidate
		}

		override public function set y(value:Number):void
		{
			if (y == value)
				return;

			super.y = value;
			// TODO : position invalidate
		}

		// ------------------------------------------------------------------------ Transform

		// Drag ------------------------------------------------------------------------

		protected var _dragArea:DisplayObject;

		private var _isDraggable:Boolean;

		public function get isDraggable():Boolean
		{
			return _isDraggable;
		}

		public function set isDraggable(value:Boolean):void
		{
			_isDraggable = value;

			if (!_dragArea)
				_dragArea = this;

			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);

			if (value)
				_dragArea.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
		}

		protected function onDrag(event:MouseEvent):void
		{
			parent.setChildIndex(this, parent.numChildren - 1);
			startDrag(false); //, root.scrollRect);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, onDrop, false, 0, true);
			event.updateAfterEvent();
		}

		protected function onDrop(event:MouseEvent):void
		{
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(Event.MOUSE_LEAVE, onDrop);
			event.updateAfterEvent();
		}

		// ------------------------------------------------------------------------ Drag

		override public function destroy():void
		{
			// event
			removeEventListener(Event.ADDED_TO_STAGE, onStage);

			if (_dragArea)
				_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);

			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
				stage.removeEventListener(Event.MOUSE_LEAVE, onDrop);
			}

			//signal
			_transformSignal.removeAll();
			_transformSignal = null;

			// referer
			_style = null;

			super.destroy();
		}
	}
}
