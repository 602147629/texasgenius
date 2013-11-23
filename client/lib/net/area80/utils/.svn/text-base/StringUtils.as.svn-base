/*
Copyright © 2008-2011, Area80 Co.,Ltd.
All rights reserved.

Facebook: http://www.fb.com/Area80/
Website: http://www.area80.net/


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of Area80 Incorporated nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package net.area80.utils
{

	import net.area80.enum.DayMonth;


	public class StringUtils
	{

		public static const WHITESPACE:String = " \t\n\r"; /**< Whitespace characters (space, tab, new line and return). */

		/**
		* Add zero to string ex: your string is "3" then define result length to be it will returns "003".
		* @param	str
		* @param	resultLength
		* @return
		*/
		public static function addZero(num:Object, resultLength:Number):String
		{
			var str:String = String(num);
			var result:String = str;
			if (str.length < resultLength) {
				var s:String = "";
				for (var i:uint = 0; i < resultLength - str.length; i++) {
					s += "0";
				}
				result = s + str;
			}
			return result;
		}

		/**
		 * Return string in money format ex: 100,000
		 * @param value
		 * @return
		 *
		 */
		public static function moneyFormat(value:int):String
		{
			var res:String = "";
			var v:String = String(value);
			var count:uint = 0;
			for (var i:int = v.length - 1; i >= 0; i--, count++) {
				if (count % 3 == 0 && count > 0) {
					res = "," + res;
				}
				res = v.charAt(i) + res;

			}
			return res;
		}

		/**
		 * Remove white space from beginning/ending of the string
		 * @param str
		 * @return
		 *
		 */
		/*public static function trim(str:String):String {
			var res:String=str;
			while (res.charAt(0) == " ") {
				res = res.substr(1);
			}
			while (res.charAt(res.length-1) == " ") {
				res = res.substr(0,res.length-1);
			}
			return res;
		}*/
		public static function trim(source:String, removeChars:String = StringUtils.WHITESPACE):String
		{
			var pattern:RegExp = new RegExp('^[' + removeChars + ']+|[' + removeChars + ']+$', 'g');
			return source.replace(pattern, '');
		}

		/**
		 * Uppercase 1st character
		 * @param str
		 * @return
		 *
		 */
		public static function firstUpperCase(str:String):String
		{
			return String(str).substr(0, 1).toUpperCase() + String(str).substr(1);
		}

		/**
		 * Return time string in the format 05:47:22
		 * @param	d
		 * @return
		 */
		public static function getTime(d:Date):String
		{
			return addZero(d.getHours(), 2) + ":" + addZero(d.getMinutes(), 2) + ":" + addZero(d.getSeconds(), 2);
		}

		/**
		 * Return date string in format HH:MM DD THFullMonth YYYY
		 * @param d
		 * @return
		 *
		 */
		public static function getThaiDate(d:Date):String
		{
			return addZero(d.getHours(), 2) + ":" + addZero(d.getMinutes(), 2) + " " + d.getDate() + " " + DayMonth.TH_MONTH[d.getMonth()] + " " + (d.getFullYear() + 543);
		}

		/**
		 * Trim string(if set) and remove newline character
		 * @param s
		 * @param doTrimming
		 * @return
		 *
		 */
		public static function initHTMLString(s:String, doTrimming:Boolean = true):String
		{
			var str:String = (doTrimming) ? trim(s) : s;

			return str.split(String.fromCharCode(10)).join("").split(String.fromCharCode(13)).join("").split(String.fromCharCode(9)).join("");
		}

		/**
		 * Return date string in format HH:MM DD ENFullMonth YYYY
		 * @param d
		 * @return
		 *
		 */
		public static function getEnDate(d:Date):String
		{
			return addZero(d.getHours(), 2) + ":" + addZero(d.getMinutes(), 2) + " " + d.getDate() + " " + DayMonth.MONTH[d.getMonth()] + " " + (d.getFullYear());
		}
	}
}