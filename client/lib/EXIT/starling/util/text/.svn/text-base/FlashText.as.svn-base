package EXIT.starling.util.text
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import starling.display.DisplayObject;

	public class FlashText extends TextField
	{
		private var syncSpriteStaring:DisplayObject;

		public function FlashText(_str:String, _syncSpriteStaring:DisplayObject, _textFormat:TextFormat = null)
		{
			super();
			syncSpriteStaring = _syncSpriteStaring;
			if (_textFormat!=null)
				defaultTextFormat = _textFormat;
			text = _str;
		}

		public function syncToPoint(_point:Point):void
		{
			var newPoint:Point = syncSpriteStaring.localToGlobal(_point);
			x = newPoint.x;
			y = newPoint.y;
		}
	}
}
