package EXIT.math
{
	/**
	 * ...
	 * @author EXIT
	 */
	public class MathStatic
	{

		public function MathStatic()
		{

		}
		//Work like friction opposite direction of velocity and approch to zero
		public static function approach0(velocity:Number, friction:Number):Number
		{
			if (Math.abs(velocity) > friction) {
				velocity += -velocity / Math.abs(velocity) * friction;
			}else {
				velocity = 0;
			}
			return velocity;
		}
		
		
		/**
		 * like substr the first number 
		 * ex. 653 > return 6;
		 * 	   794 > return 7;
		 */		
		public static function valueOfMajor( $value : Number ):Number
		{
			while( $value >= 10 ){
				$value /= 10;
			}
			return Math.floor($value);
		}
		/**
		 * @param $index index reverse the last number, index = 1;
		 * ex. subNumber( 364 , 2 );//6
		 * 
		 */		
		public static function subNumber( $value : Number , $index : uint ):uint
		{
			return Math.floor( ( $value % Math.pow(10,$index+1) )/ Math.pow(10,$index) );
		}
		
		
		
		/**
		 * 
		 */		
	}

}
