package vo
{
	public class RoomConfig
	{
		public var minCoin:Number;
		public var maxCoin:Number;
		public var sb:Number;
		public var bb:Number;
		public function RoomConfig(_minCoin:Number,_maxCoin:Number,_sb:Number,_bb:Number)
		{
			minCoin = _minCoin;
			maxCoin = _maxCoin;
			sb = _sb;
			bb = _bb;
		}
	}
}