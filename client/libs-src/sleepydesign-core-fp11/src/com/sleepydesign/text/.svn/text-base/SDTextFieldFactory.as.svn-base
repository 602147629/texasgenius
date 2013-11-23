package com.sleepydesign.text
{
	import flash.text.TextFormat;

	public class SDTextFieldFactory
	{
		private static const _DEFAULT_TEXTFORMAT:TextFormat = new TextFormat("Tahoma", 12, 0x000000);

		public static function build(text:String = null, textFormat:TextFormat = null, embedFonts:Boolean = true):SDTextField // fontName:String = "Tahoma", fontSize:Number = 12, fontColor:int = 0x000000):SDTextField
		{
			return new SDTextField(text, textFormat || _DEFAULT_TEXTFORMAT, embedFonts);
		}

		public static function buildHTMLText(htmlText:String = null, textFormat:TextFormat = null, embedFonts:Boolean = true):SDTextField // fontName:String = "Tahoma", fontSize:Number = 12, fontColor:int = 0x000000):SDTextField
		{
			const sdTF:SDTextField = new SDTextField(htmlText, textFormat || _DEFAULT_TEXTFORMAT, embedFonts);
			sdTF.multiline = true;
			sdTF.htmlText = htmlText;
			return sdTF;
		}
	}
}
