package com.sleepydesign.utils
{
	import com.hurlant.util.Base64;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * @author katopz
	 */
	public class Base64Util
	{
		public static function encode(value:String, isZip:Boolean = false, isEscape:Boolean = false):String
		{
			// value -> ByteArray
			const tempByteArray:ByteArray = new ByteArray();
			tempByteArray.writeUTFBytes(isEscape ? escape(value) : value);

			// compress
			if (isZip)
				tempByteArray.compress();
			
			// ByteArray -> Base64
			return Base64.encodeByteArray(tempByteArray);
		}

		public static function decode(value:String, isZip:Boolean = false, isUnescape:Boolean = false):String
		{
			// Base64 -> ByteArray
			const tempByteArray:ByteArray = Base64.decodeToByteArrayB(value);

			// uncompress
			if (isZip)
				tempByteArray.uncompress();

			// ByteArray -> value
			const result:String = tempByteArray.readUTFBytes(tempByteArray.length);
			return isUnescape ? unescape(result) : result;
		}

		public static function bitmapDataToBase64(bitmapData:BitmapData):String
		{
			const byteArray:ByteArray = bitmapData.getPixels(bitmapData.rect);
			byteArray.compress();

			return Base64.encodeByteArray(byteArray);
		}

		public static function base64ToBitmapData(base64:String, w:Number, h:Number):BitmapData
		{
			const resultBMPDAT:BitmapData = new BitmapData(w, h);
			const byteArray:ByteArray = Base64.decodeToByteArrayB(base64);
			byteArray.uncompress();

			resultBMPDAT.setPixels(new Rectangle(0, 0, w, h), byteArray);

			return resultBMPDAT;
		}
	}
}
