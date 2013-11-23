package EXIT.math
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class ResizeRectangle
	{
		public function ResizeRectangle()
		{
		}
		
		public static function fitToWidthHeight( _object:DisplayObject , _width:Number , _height:Number):void
		{
			var scaleX:Number = _width/_object.width;
			var scaleY:Number = _height/_object.height;
			if( scaleX < scaleY ){
				_object.width = _width;
				_object.scaleY = _object.scaleX;
			}else{
				_object.height = _height;
				_object.scaleX = _object.scaleY;
			}
			_object.x = (_width-_object.width)*.5;
			_object.y = (_height-_object.height)*.5;
		}
	}
}