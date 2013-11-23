package net.area80.utils
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class GoogleMapUtils
	{
		public static function composeMapRouteUrl(
			fromlatlng:String,
			tolatlng:String,
			fromlabel:String = "",
			tolabel:String = ""):String
		{
			if (fromlabel!="")
				fromlabel = fromlabel+"@";
			if (tolabel!="")
				tolabel = tolabel+"@";
			return "http://maps.google.com/maps?daddr="+tolabel+tolatlng+"&saddr="+fromlabel+fromlatlng;
		}

		public static function navigateToMapRouteUrl(
			fromlatlng:String,
			tolatlng:String,
			fromlabel:String = "",
			tolabel:String = "",
			target:String = "_self"):void
		{
			var url:String = composeMapRouteUrl(fromlatlng, tolatlng, fromlabel, tolabel);
			navigateToURL(new URLRequest(url), target);
		}
	}
}
