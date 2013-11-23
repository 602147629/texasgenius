package EXIT 
{
	import away3d.loaders.Obj;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author EXIT[flashdevelop]
	 */
	public class XmlLoaderClass extends Sprite
	{
		var contentXML:XML;
		var allAttributes:Array = new Array();
		public var xmlArray:Array = new Array();
		public function XmlLoaderClass(xmlPath,attributes)
		{
			var xmlLoader:URLLoader = new URLLoader(new URLRequest(xmlPath));
			allAttributes = attributes;
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
		}
		private function xmlLoaded(e:Event) {			
			contentXML = new XML(e.currentTarget.data);
			firstLevelXMLtoArray();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function firstLevelXMLtoArray() {
			
			var myChild = contentXML.children();
			for (var i in myChild) {				
				trace(i + ' : ' + myChild[i] + ' : ' + myChild[i].attributes());
				xmlArray.push( { child:myChild[i] } );
				for (var j in allAttributes) {
					xmlArray[i][allAttributes[j]] = myChild[i].attribute(allAttributes[j]);
					trace(allAttributes[j]+' :::: '+xmlArray[i][allAttributes[j]]);
				}
			}
		}
	}
}