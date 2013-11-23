package com.sleepydesign.components
{
	import com.sleepydesign.components.styles.ISDStyle;

	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class SDButton extends SDComponent
	{
		private var _label:TextField;
		private var _labelText:String = "";

		private var _selected:Boolean = false;
		private var _down:Boolean = false;
		private var _toggle:Boolean = false;

		public function SDButton(text:String = "", buttonWidth:Number = NaN, buttonHeight:Number = NaN, style:ISDStyle = null)
		{
			super(style);

			_labelText = text;

			addChild(_back = new Shape);
			addChild(_label = new TextField);
			_label.autoSize = TextFormatAlign.CENTER;
			_label.mouseEnabled = _label.mouseWheelEnabled = false;
			_label.defaultTextFormat = new TextFormat("Tahoma", 11, _style.color);
			_label.text = text;

			buttonMode = true;
			useHandCursor = true;

			setSize(isNaN(buttonWidth) ? _label.width + 4 : buttonWidth, isNaN(buttonHeight) ? 20 : buttonHeight);
		}

		override public function draw():void
		{
			_label.autoSize = TextFormatAlign.CENTER;
			_label.text = _labelText;

			if (_label.width > _width - 4)
			{
				_label.autoSize = "none";
				_label.width = _width - 4;
			}
			else
			{
				_label.autoSize = TextFormatAlign.CENTER;
			}

			_label.x = (_width - _label.width) * .5;
			_label.y = (height - _label.height) * .5;

			if (_width < _label.width + 4)
				setSize(_label.width + 4, _height);

			drawBack(0, 0, _width, _height, _style.border_radius, _style.border_radius);

			super.draw();
		}

		public function set label(str:String):void
		{
			_labelText = str;
			draw();
		}

		public function get label():String
		{
			return _labelText;
		}

		public function set selected(value:Boolean):void
		{
			if (!_toggle)
				return;

			_selected = value;
			_down = _selected;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set toggle(value:Boolean):void
		{
			_toggle = value;
		}

		public function get toggle():Boolean
		{
			return _toggle;
		}
	}
}
