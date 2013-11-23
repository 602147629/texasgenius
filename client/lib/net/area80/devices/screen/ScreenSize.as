package net.area80.devices.screen
{

	public class ScreenSize
	{

		public var portWidth:uint;
		public var portHeight:uint;
		public var pixelDensity:Number;

		public function ScreenSize(portWidth:uint, portHeight:uint, pixelDensity:Number = 1)
		{
			this.portWidth = portWidth;
			this.portHeight = portHeight;
			this.pixelDensity = pixelDensity;
		}
	}
}
