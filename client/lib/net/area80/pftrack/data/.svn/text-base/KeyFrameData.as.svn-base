package net.area80.pftrack.data
{
	public class KeyFrameData
	{
		public var frame:uint = 0;
		public var time:Number = 0;
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		public var roll:Number = 0;
		public var pitch:Number = 0;
		public var yaw:Number = 0;
		public var quaternion:Array = [0,0,0,0];
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var scaleZ:Number = 1;
		public var position:String;
		public var projection:String;
		public function KeyFrameData()
		{
		}
		public static function createFromXML (data:XML):KeyFrameData {
			var k:KeyFrameData = new KeyFrameData();
			k.frame = uint(data.frame.toString());
			k.time = Number(data.time.toString());
			k.x = Number(data.translate.toString().split(" ")[0]);
			k.y = Number(data.translate.toString().split(" ")[1]);
			k.z = Number(data.translate.toString().split(" ")[2]);
			k.roll = Number(data.rotate.rollPitchYaw.toString().split(" ")[0]);
			k.pitch = Number(data.rotate.rollPitchYaw.toString().split(" ")[1]);
			k.yaw = Number(data.rotate.rollPitchYaw.toString().split(" ")[2]);
			k.quaternion[0] = Number(data.rotate.quaternion.toString().split(" ")[0]);
			k.quaternion[1] = Number(data.rotate.quaternion.toString().split(" ")[1]);
			k.quaternion[2] = Number(data.rotate.quaternion.toString().split(" ")[2]);
			k.quaternion[3] = Number(data.rotate.quaternion.toString().split(" ")[3]);
			k.scaleX = Number(data.scale.toString().split(" ")[0]);
			k.scaleY = Number(data.scale.toString().split(" ")[0]);
			k.scaleZ = Number(data.scale.toString().split(" ")[0]);
			return k;
		}

	}
}