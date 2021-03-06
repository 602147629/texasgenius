package net.area80.pftrack.utils
{
	public class Quaternion {
		private var $y:Number;
		private var $z:Number;
		private var $w:Number;
		private var $x:Number;
		
		public function Quaternion(a:Number, b:Number, c:Number, d:Number) {
			$x = a ? a : 0;
			$y = b ? b : 0;
			$z = c ? c : 0;
			$w = d ? d : 1; 
		}
		
		public function get x():Number {
			return $x;
		}
		
		public function get y():Number {
			return $y;
		}
		
		public function get z():Number {
			return $z;
		}
		
		public function get w():Number {
			return $w;
		}
		
		public function fromPoint(a:Number, b:Number, c:Number):void {
			$x = a;
			$y = b;
			$z = c;
			$w = 0;
		}
		
		public function fromAxisAngle(a:Number, b:Number, c:Number, d:Number):void {
			var ca:Number = Math.cos(d/2); var sa:Number = Math.sin(d/2);
			var m:Number = Math.sqrt(a*a + b*b + c*c);
			$x = a/m * sa;
			$y = b/m * sa;
			$z = c/m * sa;
			$w = ca;
		}
		
		public function concat(q:Quaternion):void {
			var w1:Number = $w; var x1:Number = $x; var y1:Number = $y; var z1:Number = $z;
			var w2:Number = q.w; var x2:Number = q.x; var y2:Number = q.y; var z2:Number = q.z;
			$w = w1*w2 - x1*x2 - y1*y2 - z1*z2
			$x = w1*x2 + x1*w2 + y1*z2 - z1*y2
			$y = w1*y2 + y1*w2 + z1*x2 - x1*z2
			$z = w1*z2 + z1*w2 + x1*y2 - y1*x2
		}
		
		public function invert():void {
			$x = -$x;
			$y = -$y;
			$z = -$z;
		}
		
		public function copy():Quaternion {
			return new Quaternion($x, $y, $z, $w);
		}
	}
}