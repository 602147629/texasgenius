package net.area80.facebook.graph
{

	public class FBGraphUtils
	{
		public static const HTTP:String = "http://graph.facebook.com/";
		public static const HTTPS:String = "https://graph.facebook.com/";

		public static function getProfileImagePath(id:String = "me"):String
		{
			return HTTP + id + "/picture/";
		}

		public static function getBigProfileImagePath(id:String = "me"):String
		{
			return HTTP + id + "/picture/?type=large";
		}

		public static function getNormalProfileImagePath(id:String = "me"):String
		{
			return HTTP + id + "/picture/?type=normal";
		}

		public static function getPhotoPath(postid:String):String
		{
			return "http://www.facebook.com/photo.php?fbid=" + postid;
		}
	}
}
