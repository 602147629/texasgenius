package net.area80.pftrack.data
{
	public class PFTrackData
	{
		public var fileInfo:PFTrackFileInfoData;
		public var cameraKeyFrames:Array;
		public var keyFrames:Array;
		public var numFrame:uint;
		public var frameRate:uint;
		public var stageWidth:uint;
		public var stageHeight:uint;
		public var features:Vector.<FeatureData>;
		
		public function PFTrackData()
		{
		}
		public static function createFromXML (xml:XML, numFrame:uint=0):PFTrackData {
			var fbxData:PFTrackData = new PFTrackData();
			fbxData.fileInfo = PFTrackFileInfoData.createFromXML(xml.info[0]);
		
			fbxData.numFrame = (numFrame==0) ? int(xml.camera.cameraData.numFrame) : numFrame;
			fbxData.frameRate = int(xml.camera.cameraData.frameRate);
			fbxData.stageWidth = int(String(xml.camera.cameraData.resolution).split(" ")[0]);
			fbxData.stageHeight = int(String(xml.camera.cameraData.resolution).split(" ")[1]);
			fbxData.cameraKeyFrames = new Array(fbxData.numFrame);
			fbxData.keyFrames = new Array(fbxData.numFrame);
			fbxData.features = new Vector.<FeatureData>;
			var cFrame:uint;
			for each (var cameraKeyFrame:* in xml.camera.keyFrame) {
				cFrame = int(cameraKeyFrame.frame);
				fbxData.cameraKeyFrames[cFrame] = CameraFrameData.createFromXML(cameraKeyFrame);
			}
			for each (var groupKeyFrame:* in xml.group.keyFrame) {
				cFrame = int(groupKeyFrame.frame);
				fbxData.keyFrames[cFrame] = KeyFrameData.createFromXML(groupKeyFrame);
			}
			
			for each (var feature:* in xml.group.feature) {
				var fdata:FeatureData = new FeatureData();
				fdata.name = String(feature.name);
				fdata.keyFrames = new Array(fbxData.numFrame);
				var translate:String =  String(feature.translate);
				for each (var kf:* in feature.track.keyFrame) {
					cFrame = int(kf.frame);
					var data:XML = kf;
					var k:KeyFrameData = new KeyFrameData();
					k.frame = uint(data.frame.toString());
					k.time = Number(data.time.toString());
					k.x = Number(translate.split(" ")[0]);
					k.y = Number(translate.split(" ")[1]);
					k.z = Number(translate.split(" ")[2]);
					k.position = data.position.toString();
					k.projection = data.projection.toString();

					fdata.keyFrames[cFrame] = k;
				}
				fbxData.features.push(fdata);
			}
			return fbxData;
		}

	}
}