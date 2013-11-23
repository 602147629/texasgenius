package module.roompage.friendmodule
{
	public class FriendData{
		public var nameFriend:String;
		public var money:String;
		public var uid:String;
		public function FriendData(_name:String,_money:String,_uid:String):void
		{
			nameFriend = _name;
			money = _money;
			uid = _uid;
		}
	}
}