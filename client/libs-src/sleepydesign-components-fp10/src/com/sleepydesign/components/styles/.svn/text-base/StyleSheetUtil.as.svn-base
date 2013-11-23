package com.sleepydesign.components.styles
{
	import flash.text.StyleSheet;

	public class StyleSheetUtil
	{
		public static function parseCSS(css:String = null):StyleSheet
		{
			var style:StyleSheet = new StyleSheet();
			var p:String;
			var aLink:String;
			var aHover:String;
			
			if (!css)
			{
				p = "p {font-family: Tahoma;font-size: 12px;color:#000000;}";
				aLink = "a:link {color:#009900;}";
				aHover = "a:hover {color:#00CC00;text-decoration:underline}";
				css = p + aLink + aHover;
			}
			
			style.parseCSS(css);
			//styleSheet = style;
			
			return style;
		}
	}
}