package EXIT.util
{
	public class ArrayUtils
	{
		public static function moveIndex( $array:* , $fromLayer:Number , $toLayer:Number ):void
		{
			var fromItem:* = $array[$fromLayer];
			if( $toLayer < $fromLayer ){
				$fromLayer++;
			}
			$array.splice( $toLayer , 0 , fromItem );
			$array.splice( $fromLayer , 1 );
		}
		
		public function ArrayUtils()
		{
		}
	}
}