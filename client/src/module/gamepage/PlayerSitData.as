package module.gamepage
{
	public class PlayerSitData
	{
		public var userId:int;
		public var fbuid:String 
		public var sitPosition:int;
		public var playerStatus:String;
		public var isMe:Boolean;
		public function PlayerSitData(userId:int,fbuid:String,sitPosition:int,playerStatus:String,isMe:Boolean)
		{
			this.userId = userId;
			this.fbuid = fbuid;
			this.sitPosition = sitPosition;
			this.playerStatus = playerStatus;
			this.isMe = isMe;
		}
	}
}