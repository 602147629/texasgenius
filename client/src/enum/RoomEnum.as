package enum
{
	import vo.RoomConfig;

	public class RoomEnum
	{
		public const ZONE_1_1:RoomConfig = new RoomConfig( 400 , 8000 , 20 , 40 );
		public const ZONE_1_2:RoomConfig = new RoomConfig( 500 , 10000 , 25 , 50 );
		
		public const ZONE_2_1:RoomConfig = new RoomConfig( 1000 ,  20000 ,  50 , 100 );
		public const ZONE_2_2:RoomConfig = new RoomConfig( 2000 ,  80000 ,  100 , 200 );
		public const ZONE_2_3:RoomConfig = new RoomConfig( 5000 ,  100000 , 250 , 500 );
		public const ZONE_2_4:RoomConfig = new RoomConfig( 10000 , 200000 , 500 , 1000 );
		
		public const ZONE_3_1:RoomConfig = new RoomConfig( 10000 , 2000000 , 5000 , 10000 );
		public const ZONE_3_2:RoomConfig = new RoomConfig( 40000 , 2000000 , 5000 , 10000 );
		
		
		public function RoomEnum()
		{
		}
	}
}