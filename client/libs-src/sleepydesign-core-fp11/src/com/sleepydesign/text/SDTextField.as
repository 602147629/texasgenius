package com.sleepydesign.text
{
	import com.sleepydesign.core.IDestroyable;
	
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SDTextField extends TextField implements IDestroyable
	{
		public function SDTextField(text:String = null, textFormat:TextFormat = null, embedFonts:Boolean = true)
		{
			super();

			selectable = false;
			mouseEnabled = false;
			mouseWheelEnabled = false;

			autoSize = TextFieldAutoSize.LEFT;
			defaultTextFormat = textFormat ? textFormat : defaultTextFormat;

			cacheAsBitmap = true;
			this.embedFonts = textFormat && embedFonts;

			// force cached as bitmap
			filters = [new GlowFilter(0x000000, 0, 0, 0, 0, 0)];

			// TODO : move to TextFieldUtil
			//parseCSS(css);

			if (text)
				this.text = text;
		}

		protected var _isDestroyed:Boolean;

		private var _htmlTextP:String;

		public function get htmlTextP():String
		{
			return _htmlTextP;
		}

		public function set htmlTextP(value:String):void
		{
			if (_htmlTextP == value)
				return;

			_htmlTextP = value;

			htmlText = "<p>" + value + "</p>";
		}

		public function get destroyed():Boolean
		{
			return this._isDestroyed;
		}

		public function destroy():void
		{
			this._isDestroyed = true;

			if (this.parent != null)
				this.parent.removeChild(this);
		}
	}
}
