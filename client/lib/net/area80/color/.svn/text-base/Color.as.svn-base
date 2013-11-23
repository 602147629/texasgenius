package net.area80.color {
	
	/**
	 * Color
	 * @author Wissarut Pimanmassuriya
	 */
	public class Color {
		private var _r:Number = 1;
		private var _g:Number = 1;
		private var _b:Number = 1;
		
		public function get r ():Number { return Math.min(255,Math.max(1,_r)); }
		public function set r (n:Number):void { _r =  Math.min(255, Math.max(1, n)); }
		public function get g ():Number { return Math.min(255,Math.max(1,_g)); }
		public function set g (n:Number):void { _g =  Math.min(255, Math.max(1, n)); }
		public function get b ():Number { return Math.min(255,Math.max(1,_b)); }
		public function set b (n:Number):void { _b =  Math.min(255,Math.max(1,n)); }
		
		public function Color (n:Number):void {
				value = n;
		}
		public function get value ():Number {
				return (r << 16 | g << 8 | b);
		}
		public function set value (n:Number):void {
				createFromNumber(n);
		}
		
		private function createFromNumber (n:Number):void {
				r = (n >> 16 & 0xFF);
				g = (n >> 8 & 0xFF);
				b = (n & 0xFF);
		}
		

	}
	
}