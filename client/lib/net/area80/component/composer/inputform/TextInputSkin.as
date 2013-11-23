package net.area80.component.composer.inputform
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class TextInputSkin extends Sprite
	{
		public var textField:TextField; //required
		/**
		 * MovieClip which has 2 frames, hilighted when focused. (not required)
		 */
		public var backgroundClip:MovieClip;
		public var focusAlpha:Number = 1;
	}
}
