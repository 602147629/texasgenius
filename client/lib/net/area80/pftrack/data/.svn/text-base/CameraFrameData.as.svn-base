package net.area80.pftrack.data
{
	public class CameraFrameData
	{
		public var fieldOfView:Array;
		public var focalLength:Number;
		public var frame:uint = 0;
		public var time:Number = 0;
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		public var roll:Number = 0;
		public var pitch:Number = 0;
		public var yaw:Number = 0;
		public var quaternion:Array = [0,0,0,0];
		
		public function CameraFrameData()
		{
		}
		
		public static function createFromXML (data:XML):CameraFrameData {
			//[Object CameraFrameData {z:40, frame:0, y:10, focalLength:34.2504, pitch:2.33846e-15, time:0, x:0, fieldOfView:45,26.2688, roll:-1.27518e-30, yaw:9.16388e-49, quaternion:2.04069e-17,-2.1909299999999996e-49,-1.11281e-32,1}];
				var k:CameraFrameData = new CameraFrameData();
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
				k.fieldOfView = [Number(data.fieldOfView.toString().split(" ")[0]),Number(data.fieldOfView.toString().split(" ")[1])];
				k.focalLength = Number(data.focalLength.toString());
				return k;
		}

	}
}