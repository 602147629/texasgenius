package EXIT.util
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class DrawUtil
	{
		public static function getRect($w:Number, $h:Number, $c:uint = 0x000000, $x:Number = 0, $y:Number = 0):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill($c);
			sp.graphics.drawRect($x, $y, $w, $h);
			sp.graphics.endFill();
			return sp;
		}

		public static function setRectToGR($gr:Graphics, $w:Number, $h:Number, $c:uint = 0x000000, $x:Number = 0, $y:Number = 0):void
		{
			$gr.beginFill($c);
			$gr.drawRect($x, $y, $w, $h);
			$gr.endFill();
		}

		public static function getMoveIcon():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0);
			sp.graphics.lineStyle(1, 0xFFFFFF);

			// up arrow
			sp.graphics.moveTo(1, 1);
			sp.graphics.lineTo(1, -2);
			sp.graphics.lineTo(-1, -2);
			sp.graphics.lineTo(2, -6);
			sp.graphics.lineTo(5, -2);
			sp.graphics.lineTo(3, -2);
			sp.graphics.lineTo(3, 1);
			// right arrow
			sp.graphics.lineTo(6, 1);
			sp.graphics.lineTo(6, -1);
			sp.graphics.lineTo(10, 2);
			sp.graphics.lineTo(6, 5);
			sp.graphics.lineTo(6, 3);
			sp.graphics.lineTo(3, 3);
			// down arrow
			sp.graphics.lineTo(3, 5);
			sp.graphics.lineTo(3, 6);
			sp.graphics.lineTo(5, 6);
			sp.graphics.lineTo(2, 10);
			sp.graphics.lineTo(-1, 6);
			sp.graphics.lineTo(1, 6);
			sp.graphics.lineTo(1, 5);
			// left arrow
			sp.graphics.lineTo(1, 3);
			sp.graphics.lineTo(-2, 3);
			sp.graphics.lineTo(-2, 5);
			sp.graphics.lineTo(-6, 2);
			sp.graphics.lineTo(-2, -1);
			sp.graphics.lineTo(-2, 1);
			sp.graphics.lineTo(1, 1);
			sp.graphics.endFill();
			return sp;
		}
	}
}
