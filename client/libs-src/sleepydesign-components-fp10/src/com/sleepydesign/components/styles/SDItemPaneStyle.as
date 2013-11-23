package com.sleepydesign.components.styles
{

	import flash.display.DisplayObject;

	public class SDItemPaneStyle extends SDSliderStyle implements ISDStyle
	{
		public var itemWidth:int;
		public var itemHeight:int;

		public var panelWidth:int;
		public var panelHeight:int;

		// btn
		public var nextButton:DisplayObject;
		public var prevButton:DisplayObject;

		// visibility
		private var _vscrollVisible:Boolean;
		private var _hscrollVisible:Boolean;

		private var _isNextButtonEnable:Boolean;

		public function get isNextButtonEnable():Boolean
		{
			return _isNextButtonEnable;
		}

		private var _isPrevButtonEnable:Boolean;

		public function get isPrevButtonEnable():Boolean
		{
			return _isPrevButtonEnable;
		}

		public function set isNextButtonEnable(value:Boolean):void
		{
			enableNext(_isNextButtonEnable = value);
		}

		public function set isPrevButtonEnable(value:Boolean):void
		{
			enablePrev(_isPrevButtonEnable = value);
		}

		public var enablePrev:Function = function(value:Boolean):void
		{
			if (!prevButton)
				return;

			prevButton.visible = value;
		}

		public var enableNext:Function = function(value:Boolean):void
		{
			if (!nextButton)
				return;

			nextButton.visible = value;
		}

		public var setupThumb:Function;

		override public function get background_color():uint
		{
			return 0;
		}

		override public function get background_alpha():uint
		{
			return 0;
		}

		public function set vscroll_visible(value:Boolean):void
		{
			_vscrollVisible = value;
		}

		override public function get vscroll_visible():Boolean
		{
			return _vscrollVisible;
		}

		public function set hscroll_visible(value:Boolean):void
		{
			_hscrollVisible = value;
		}

		override public function get hscroll_visible():Boolean
		{
			return _hscrollVisible;
		}

		override public function get border_width():uint
		{
			return 0;
		}

		public var useCulling:Boolean = false;
	}
}
