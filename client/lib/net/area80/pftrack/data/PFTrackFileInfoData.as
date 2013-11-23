package net.area80.pftrack.data
{
	public class PFTrackFileInfoData
	{
		public var createdBy:String;
		public var handedness:String;
		public var upDirection:String;
		public var rotateUnit:String;
		public var fieldOfViewUnit:String;
		public var focalLengthUnit:String;
		public var apertureUnit:String;
		
		public function PFTrackFileInfoData()
		{
		}
		public static function createFromXML (info:XML):PFTrackFileInfoData {
			var fileInfo:PFTrackFileInfoData = new PFTrackFileInfoData();
			fileInfo.createdBy = info.createdBy.toString();
			fileInfo.upDirection = info.coordinateSystem[0].upDirection.toString();
			fileInfo.handedness = info.coordinateSystem[0].handedness.toString();
			fileInfo.rotateUnit = info.units.rotate.toString();
			fileInfo.fieldOfViewUnit = info.units.fieldOfView.toString();
			fileInfo.focalLengthUnit = info.units.focalLength.toString();
			fileInfo.apertureUnit = info.units.aperture.toString();
			return fileInfo;
		}

	}
}