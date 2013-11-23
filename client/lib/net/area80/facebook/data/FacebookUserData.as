package net.area80.facebook.data
{
	public class FacebookUserData
	{
		public var uid:String;
		public var name:String;
		public var locale:String;
		public var link:String;
		public var first_name:String;
		public var last_name:String;
		public var gender:String;
		public var verified:Boolean;
		
		public function get languageCode ():String {
			return (locale) ? locale.split("_")[0] : "";
		}
		public function get countryCode ():String {
			return (locale) ? locale.split("_")[1] : "";
		}
	}
}