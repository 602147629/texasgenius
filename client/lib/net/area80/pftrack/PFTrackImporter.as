package net.area80.pftrack
{
	import net.area80.pftrack.data.PFTrackData;
	import net.area80.utils.FileActivity;
	
	import org.osflash.signals.Signal;
	
	public class PFTrackImporter
	{
		public var SIGNAL_LOADCOMPLETE:Signal = new Signal(PFTrackData);
		private var rawXML:XML;
		public var fbxData:PFTrackData;
		public function PFTrackImporter()
		{
		}
		public function load (path:String):void {
			
			FileActivity.loadXML(path,onLoadComplete);
			
		}
		private function onLoadComplete (xml:XML):void {
			
			fbxData = PFTrackData.createFromXML(xml);
			SIGNAL_LOADCOMPLETE.dispatch(fbxData);
			
		}

	}
}