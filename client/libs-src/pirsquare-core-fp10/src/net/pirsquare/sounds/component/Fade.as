package net.pirsquare.sounds.component
{

	public class Fade
	{
		public var timestamp:Number;
		public var time:Number;
		public var start:Number;
		public var end:Number;
		public var keepChanges:Boolean;
		public var callback:Function;
		public var oE:Boolean;

		public var d:Number;
		public var over:Boolean;

		public function Fade(t:Number, s:Number, e:Number, k:Boolean, cb:Function = null, oE:Boolean = false)
		{
			var date:Date = new Date();
			timestamp = date.getTime();

			time = t;
			start = s;
			end = e;
			keepChanges = k;
			callback = cb;
			this.oE = oE;
			d = end - start;
		}

		public function getCurrentValue(now:Number):Number
		{
			var elapsed:Number = (now - timestamp);

			if (elapsed >= time)
			{
				over = true;
				return end;
			}
			else
			{
				return start + d * (elapsed / time);
			}
		}
	}
}
