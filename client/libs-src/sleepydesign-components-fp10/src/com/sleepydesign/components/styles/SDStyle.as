package com.sleepydesign.components.styles
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;

	public class SDStyle implements ISDStyle
	{
		public function get color():uint
		{
			return 0x000333;
		}
		
		public function get background_color():uint
		{
			return 0xECECEC;
		}
		
		public function get background_alpha():uint
		{
			return 1;
		}
		
		public function get border_width():uint
		{
			return 1;
		}
		
		public function get border_color():uint
		{
			return 0xD4D4D4;
		}
		
		public function get border_alpha():uint
		{
			return 1;
		}
		
		public function get border_radius():uint
		{
			return 4;
		}
		
		//private const _effect:Boolean = TweenPlugin.activate([AutoAlphaPlugin, GlowFilterPlugin, BlurFilterPlugin]);

		/*
		private var _VSCROLL_VISIBLE:Boolean;

		public function get VSCROLL_VISIBLE():Boolean
		{
			return _VSCROLL_VISIBLE;
		}

		public function set VSCROLL_VISIBLE(value:Boolean):void
		{
			_VSCROLL_VISIBLE = value;
		}

		private var _HSCROLL_VISIBLE:Boolean;

		public function get HSCROLL_VISIBLE():Boolean
		{
			return _VSCROLL_VISIBLE;
		}

		public function set HSCROLL_VISIBLE(value:Boolean):void
		{
			_HSCROLL_VISIBLE = value;
		}

		public function get INPUT_BG_COLOR():uint
		{
			return 0xFFFFFF;
		}

		public function get INPUT_BG_ALPHA():uint
		{
			return 1;
		}
		*/
/*

		public function get BUTTON_COLOR():uint
		{
			return 0xFFFFFF;
		}

		public function get BUTTON_ALPHA():uint
		{
			return 1;
		}

		public function get BORDER_THICK():Number
		{
			return 1;
		}

		public function get BORDER_COLOR():uint
		{
			return 0x000000;
		}

		public function get BORDER_ALPHA():uint
		{
			return 1;
		}

		public function get BUTTON_UP_TWEEN():Object
		{
			return {glowFilter: {alpha: 1, blurX: 4, blurY: 4, color: 0x999999, strength: 1, quality: 1, inner: true}};
		}

		public function get BUTTON_OVER_TWEEN():Object
		{
			return {glowFilter: {alpha: 1, blurX: 4, blurY: 4, color: 0xFFFFFF, strength: 2, quality: 1, inner: true}};
		}

		public function get BUTTON_DOWN_TWEEN():Object
		{
			return {glowFilter: {alpha: 1, blurX: 4, blurY: 4, color: 0x000000, strength: 1, quality: 1, inner: true}};
		}

		public function get LABEL_TEXT():uint
		{
			return 0x000000;
		}
		*/

		/*
		   public function get INPUT_TEXT():uint{return 0x000000};

		   public function get DROPSHADOW():uint{return 0x000000};
		   public function get PANEL():uint{return 0xF3F3F3};
		   public function get PROGRESS_BAR():uint{return 0xFFFFFF};
		 */
		public function get SIZE():uint
		{
			return 10;
		}
	}
}
