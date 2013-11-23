package net.area80.color {
	import flash.display.BitmapData;
	
	/**
	 * ColorEstimator
	 * 
	 * Generate average color from given bitmap data and points
	 * 
	 * TODO ==> FINISH THIS CLASS!!! (remove bitmap data usage and use only color array to calculate)
	 * 
	 * @author Wissarut Pimanmassuriya
	 */
	public class ColorEstimator {
		
		public static const samplingPoints:Array = [ [108, 230], [110, 228],[106, 230], [104, 228],[221, 230], [223, 228], [219, 230], [217, 228]];
		//public static const samplingPoints:Array = [ [106, 230], [104, 228], [219, 230], [217, 228]];
		//public static const samplingPoints:Array = [[160, 128],[158, 126], [106, 230], [104, 228], [219, 230], [217, 228]];
		
		/**
		 * Get Color Matrix Array to apply to the target;
		 * @param	_src		DisplayObject or BitmapData to sampling
		 * @param	_target		DisplayObject or BitmapData to sampling
		 * @return	Color Matrix Array
		 */
		public static function estimateToMatrix (_src:*, _target:*):Array {
				//trace("-------------------")
				var srcColor:int = getSamplingColor(_src);
				var tgColor:int = getSamplingColor(_target);
				if (tgColor == 0) tgColor = srcColor;
				return ColorEstimator.getBalanceMatrix(srcColor, tgColor);
		}
		
		private static function getSamplingColor (src:*):uint {
				var bmpData:BitmapData;
				if(src is BitmapData) {
					bmpData = BitmapData(src).clone();
				} else {
					bmpData = new BitmapData(src.width, src.height);
					bmpData.draw(src);
				}
				var colors:Array = new Array();
				for (var i:uint = 0; i < samplingPoints.length; i++) {
						colors.push(bmpData.getPixel(samplingPoints[i][0], samplingPoints[i][1]));
				}
				var multiSampling:int = ColorEstimator.multiSample(colors);
				bmpData.dispose();
				return multiSampling;
		}
		
		public static function multiSample (colors:/*Number*/Array):Number {
				var count:int = 0;
				
				var allR:Number = 0;
				var allG:Number = 0;
				var allB:Number = 0;
				
				for (var i:int = 0; i < colors.length; i++) {
						var rS:Number = ((colors[i] >> 16) & 0xff);
						var gS:Number = ((colors[i] >> 8) & 0xff);
						var bS:Number = ((colors[i]) & 0xff);
						//trace(gS);
						//if (rS > 100 && bS>100 && gS>100 && gS<240 && bS<230) {
						if (rS > 100) {
							//not black
							allR += rS;
							allG += gS;
							allB += bS;
							count++;
						}
				}
				allR = allR / count;
				allG = allG / count;
				allB = allB / count;
			//	trace("MULTISAMP->" + ColorUtils.RGBToNumber(allR, allG, allB))
				//trace("r", allR);
				//trace("g", allG);
				//trace("b", allB);
				return ColorUtils.RGBToNumber(allR, allG, allB);
				
		}
		
		public static function getBalanceMatrix (sourceColor:uint, targetColor:uint):Array {
			var source:Color = new Color(sourceColor);
			var target:Color = new Color(targetColor);
			
			var m:Array = new Array();
			var matrix:Array = new Array();
			
			matrix = matrix.concat([source.r/target.r, 0, 0, 0, 0]); // red
			matrix = matrix.concat([0, source.g/target.g, 0, 0, 0]); // green
			matrix = matrix.concat([0, 0, source.b/target.b, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha	

			return matrix;
		}


	}
	
}