package EXIT.starling.util.text
{

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import net.area80.uikit.AppDelegate;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	import th.co.fuji.smartapplication.metadata.FujiApplicationSettings;

	public class ImageHTMLText extends Image
	{
		public static const HELVETICA_FONT:String = "Helvetica Neue,Helvetica";
		//public static const HELVETICA_FONT:String = "Tahoma";
		public static const TAHOMA_FONT:String = "Tahoma";

		//helvetica ไม่มีใน iPhone4
		public function ImageHTMLText(_str:String, _fontFamily:String = HELVETICA_FONT, _fontSize:Number = 24, _color:String = "#000000", _isBold:Boolean = false, _width:int = 0, isDebug:Boolean = false)
		{
			var bold:String = "";
			var endBold:String = "";

			if (FujiApplicationSettings.isAndroid) {
				_fontFamily = "THSarabun";
				_isBold = true;
				_fontSize = _fontSize+8;
					//_pureStr = "<font  size=\""+_fontSize+"\" color=\""+_color+"\" >"+bold+_str+endBold+"</font>";
					//_pointStr = "<font size=\""+_fontSize+"\" color=\""+_color+"\" >"+bold+farAwayPoint+"\n"+_str+"\n"+farAwayPoint+endBold+"</font>";
			}

			if (_isBold) {
				bold = "<b>";
				endBold = "</b>";
			}
//			<P ALIGN="LEFT"><FONT FACE="Times New Roman" SIZE="12" COLOR="#000000" LETTERSPACING="0" KERNING="0"><b>Lorem ipsum dolor sit amet.</b></FONT></P>
			var _pureStr:String = "";
			var _pointStr:String = "";
			var farAwayPoint:String = "                                                                                                                      .";

			//} else {
			_pureStr = "<font face=\""+_fontFamily+"\" size=\""+_fontSize+"\" color=\""+_color+"\" >"+bold+_str+endBold+"</font>";
			_pointStr = "<font face=\""+_fontFamily+"\" size=\""+_fontSize+"\" color=\""+_color+"\" >"+bold+farAwayPoint+"\n"+_str+"\n"+farAwayPoint+endBold+"</font>";
			//}
			var label:flash.text.TextField = new TextField();
			if (FujiApplicationSettings.isAndroid) {
				//label.styleSheet = FujiApplicationSettings.fontStyleSheet;
				label.embedFonts = true;

			}
			label.wordWrap = (_width==0)?false:true;
			if (_width!=0)
				label.width = _width;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.htmlText = _pureStr;

			/// add (.) far away at the first and the last line to fix Helveticanue (device font) สระโดนตัดบนสุดและล่างสุด
			var width:Number = label.width;
			label.htmlText = _pointStr;
			//__________________________


			if (isDebug) {
				trace("width:"+width, label.width);
				label.selectable = true;
				AppDelegate.flashStage.addChild(label);
			}


			var padding:Number = _fontSize;
			/*if (FujiApplicationSettings.isAndroid) {
				padding += 15;
			}*/
			var bmpd:BitmapData = new BitmapData(width, label.height-2*padding, true, 0);
			var matrix:Matrix = new Matrix();
			matrix.translate(0, -padding);
			bmpd.draw(label, matrix);


			/*if(isDebug){
			label.selectable = true;
			AppDelegate.flashStage.addChild(label);
			}

			var bmpd:BitmapData = new BitmapData( label.width , label.height , true , 0 );
			bmpd.draw(label );*/

			super(Texture.fromBitmapData(bmpd, false));
		}

		/*public function set moveAble(_moveAble:Boolean):void
		{
			var touchComposer:TouchComposer = new TouchComposer(this);
			touchComposer.mouseDown(function(e:TouchEvent):void
			{
				touchComposer.mouseMove(function(e:TouchEvent):void
				{
					var img:DisplayObject = DisplayObject(e.currentTarget);
					var touch:Touch = e.getTouch( img.parent );
					var point:Point = globalToLocal( new Point(touch.globalX,touch.globalY) );
					img.x = point.x;
					img.y = point.y;
				});
			});
			touchComposer.mouseUp(function(e:TouchEvent):void
			{
				touchComposer.mouseMove(null);
			});
		}*/

		public function setAlignCenter(_x:Number, _width:Number):void
		{
			x = _x+(_width-width)*.5;
		}
	}
}
