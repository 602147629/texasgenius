package EXIT.starling.util.text
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import net.area80.uikit.AppDelegate;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class ImageTextField extends Image
	{
		public function ImageTextField( _str:String , _textFormat:TextFormat=null , _filter:Array=null , isDebug:Boolean=false )
		{
			var format:TextFormat;
			if( _textFormat ){
				format = _textFormat;
			}else{
				format = new TextFormat();
				format.font = "Tahoma";
				format.color = 0xFF0000;
				format.size = 20;
			}
			var label:TextField = new TextField();
			label.defaultTextFormat = format;
			label.wordWrap = false;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = _str;
			label.filters = _filter;
			
			/// add (.) far away at the first and the last line to fix Helveticanue (device font) สระโดนตัดบนสุดและล่างสุด
			var width:Number = label.width;
			var farAwayPoint:String = "                                                                                                                      .";
			label.text = farAwayPoint+"\n"+_str+"\n"+farAwayPoint;//"ป่ำปี้ก้ปุ้ฐญ ง่งุ่งิ้ \n ป่ำปี้ก้ปุ้ฐญ ง่งุ่งิ้";
			//__________________________
			
			
			if(isDebug){
				trace("width:"+width , label.width);
				label.selectable = true;
				AppDelegate.flashStage.addChild(label);
			}
			
			var padding:Number = Number(format.size);
			var bmpd:BitmapData = new BitmapData( width , label.height- 2*padding , true , 0 );
			var matrix:Matrix = new Matrix();
			matrix.translate(0,-padding);
			bmpd.draw(label , matrix );
			
			
			/*if(isDebug){
				label.selectable = true;
				AppDelegate.flashStage.addChild(label);
			}
			
			var bmpd:BitmapData = new BitmapData( label.width , label.height , true , 0 );
			bmpd.draw(label );*/
			
			super( Texture.fromBitmapData(bmpd,false) );
		}
		
		public function setAlignCenter( _x:Number , _width:Number ):void
		{
			x = _x+(_width-width)*.5;
		}
	}
}