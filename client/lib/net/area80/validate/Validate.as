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
package net.area80.validate {
	import net.area80.utils.StringUtils;

		public class Validate {

			private static const NUMERIC_CHARS:String = "0123456789";
			private static const LEGAL_CHARS:String = "abcdefghijklmnopqrstuvwxyz"+NUMERIC_CHARS;
			private static const ALL_CHARS:String = LEGAL_CHARS+"-_";
			private static const ALLOWED_PHONE_CHARS:String = " -+()";
			public static const EMAIL_RESTRICT:String = "a-zA-Z0-9\\@\\-\\_\\.";

			
			/**
			 * check if the string is phone number with/without countrycode
			 * @param phoneNumber
			 * @return 
			 * 
			 */
			public static function isPhoneNumber (phoneNumber:String):Boolean
			{
				var countryCode:String  = "((\\+|00)?([1-9]|[1-9][0-9]|[1-9][0-9]{2}))";
				var num:String      = "([0-9]{3,10})";
				phoneNumber = phoneNumber.match(/[\+\d]/g).join('');
				var phone:RegExp = new RegExp("^" + countryCode + num +"$");
				
				return phone.test(phoneNumber);
			}
			
			/**
			 * Check if the string is web format 
			 * @param address
			 * @param allowFTP
			 * @return 
			 * 
			 */
			public static function ifWebAddress(address:String, allowFTP:Boolean=false):Boolean
			{
				var protocol:String     = (allowFTP) ? "(https?:\/\/|ftp:\/\/)?" : "(https?:\/\/)?";
				var domainName:String   = "([a-z0-9.-]{2,})";
				var domainExt:String    = "([a-z]{2,6})";
				var web:RegExp          = new RegExp('^' + protocol + '?' + domainName + "\." + domainExt + '$', "i");
				
				return web.test(address);
			}
			/**
			 * Check if string is credit card format 
			 * @param ccNumber
			 * @return 
			 * 
			 */
			public static function validateCardNumber(ccNumber:String):Boolean
			{
				var americanExpress:RegExp  = /^(34|37) ([0-9]{13})$/x;
				var dinnersClub:RegExp      = /^(30[0-5]) ([0-9]{13})$/x;
				var masterCard:RegExp       = /^(5[1-5]) ([0-9]{14})$/x;
				var visa:RegExp             = /^4 ([0-9]{12} | [0-9]{15})$/x;
				var valid:Boolean;
				ccNumber = ccNumber.match(/\d/g).join('');
				
				if (americanExpress.test(ccNumber) || dinnersClub.test(ccNumber) ||
					masterCard.test(ccNumber) || visa.test(ccNumber))
					valid = true;
				
				return valid && luhnChecksum(ccNumber);
			}
			
			/**
			 * Check sum of a credit card 
			 * @param number
			 * @return 
			 * 
			 */
			private static function luhnChecksum(number:String):Boolean
			{
				var digits:Array = number.split('');
				var start:uint = (number.length % 2 == 0) ? 0:1;
				var sum:int;
				
				while (start < digits.length)
				{
					digits[start] = uint(digits[start]) * 2;
					start += 2;
				}
				
				digits = digits.join('').split('');
				
				for (var i:uint = 0; i < digits.length; i++)
				{
					sum += uint(digits[i]);
				}
				return (sum % 10 == 0);
			}
			/**
			 * Check if the string is date format (01.06.2010, 01/06/2010, 1/6/2010
			 * @param date
			 * @return 
			 * 
			 */
			public static function isDateString (date:String):Boolean
			{
				var month:String 		= "(0?[1-9]|1[012])";
				var day:String 			= "(0?[1-9]|[12][0-9]|3[01])";
				var year:String 		= "([1-9][0-9]{3})";
				var separator:String 	= "([.\/ -]{1})";
				
				var usDate:RegExp = new RegExp("^" + month + separator + day + "\\2" + year + "$");
				var ukDate:RegExp = new RegExp("^" + day + separator + month + "\\2" + year + "$");
				
				return (usDate.test(date) || ukDate.test(date) ? true:false);
			}
			
			/**
			 * Check if input string is an Email 
			 * @param strEmail
			 * @return 
			 * 
			 */
			public static function email(strEmail:String):Boolean {
				
				var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/i;
				return emailExpression.test(strEmail);

			}
			/**
			 * Return a slugified version of the string “10 Tips to a Better Life!” would be “10-tips-to-a-better-life” 
			 * @param string
			 * @return 
			 * 
			 */
			public static function slugify(string:String):String
			{
				const pattern1:RegExp = /[^\w- ]/g; // Matches anything except word characters, space and -
				const pattern2:RegExp = / +/g; // Matches one or more space characters
				var s:String = string;
				return s.replace(pattern1, "").replace(pattern2, "-").toLowerCase();
			}
			
			/**
			 * Strip http:// or https:// From a String, Optionally Removing www. 
			 * @param string
			 * @param stripWWW
			 * @return 
			 * 
			 */
			public static function stripHttp (string:String, stripWWW:Boolean = false):String
			{
				var s:String = string;
				var regexp:RegExp = new RegExp(!stripWWW ? "https*:\/\/" : "https*:\/\/(www\.)*", "ig");
				return s.replace(regexp, "");
			}
			
			/**
			 * Strip HTML Markup from the string
			 * @example “<strong>Click <a href=’http://example.com’>here</a> to find out more</strong>” would simply be converted to “Click here to find out more.”
			 * @param string
			 * @return 
			 * 
			 */
			public static function stripHTMLTags(string:String):String
			{
				var s:String = string;
				var regexp:RegExp = new RegExp("<[^<]*<", "gi");
				return s.replace(regexp, "");
			}
			/**
			 * Return true if the string is "true" or "false"
			 * @param s
			 * @return 
			 * 
			 */
			public static function boolean (s:String):Boolean {
				return (s == "true" || s == "false");
			}
			
			
			/**
			 * Return true if specify string is in the array list 
			 * @param s
			 * @param v
			 * @return 
			 * 
			 */
			public static function isInList (s:String, v:Array):Boolean{
				
				for(var i:uint=0; i<v.length; i++){
					if(v[i] == s){
						return true;
					}
				}
				return false;
			}
			
			/**
			 * return true if the string is length of 10 and start with "08" 
			 * @param s
			 * @return 
			 * 
			 */
			public static function mobile08 (s:String):Boolean {
				if (s.length!= 10 || s.indexOf("08") != 0) return false;
				return true;
			}
			
			/**
			 * Check if the string contains only numeric characters 
			 * @param s
			 * @return 
			 * 
			 */
			public static function numeric(s:String):Boolean { //contains only numeric characters

				if(s == ""){return false;}
				
				var iPos:Number = 0;
				while (iPos < s.length) {
					var charToCheck:String = s.charAt(iPos);
					if (NUMERIC_CHARS.indexOf(charToCheck) == -1) {
						return false;
					}
					
					iPos++;
				}
				return true;
			}
			
			/**
			 * Check if the string contains only numeric characters," ","+","-","(",")", but not just a space or empty string
			 * @param s
			 * @return 
			 * 
			 */
			public static function phone(s:String):Boolean {
				if(typeof s != "string"){return false;} //since TYPE only counts in the Editor :~)
				if(s == " " || s == ""){return false;}
				
				var iPos:Number = 0;
				while (iPos < s.length) {
					var charToCheck:String = s.charAt(iPos);
					if (NUMERIC_CHARS.indexOf(charToCheck) == -1 && ALLOWED_PHONE_CHARS.indexOf(charToCheck) == -1) {
						return false;
					}

					iPos++;
				}
				return true;
			}
			
			
			/**
			 * Remove XML namespaces from specify XML 
			 * @param xml without namespaces
			 * @return 
			 * 
			 */
			public static function stripXMLNamespaces(xml:XML):XML
			{
				var s:String = xml.toString();
				var pattern1:RegExp = /\s*xmlns[^\'\"]*=[\'\"][^\'\"]*[\'\"]/gi;
				s = s.replace(pattern1, "");
				var pattern2:RegExp = /&lt;[\/]{0,1}(\w+:).*?&gt;/i;
				while(pattern2.test(s)) {
					s = s.replace(pattern2.exec(s)[1], "");
				}
				return XML(s);
			}
			
			/**
			 * Check if string is not empty or be white spaces 
			 * @param s
			 * @return 
			 * 
			 */
			public static function notempty(s:String):Boolean{
				return (StringUtils.trim(s) != "");
			}
			
			/**
			 * Check if string length is specify length 
			 * @param s
			 * @param aLengths
			 * @return 
			 * 
			 */
			public static function fixedLength(s:String, aLengths:Array):Boolean{ //fks. [0,16,24] == a string of 0 or 16 or 24 characters length
				for(var i:uint=0; i<aLengths.length; i++){
					if(s.length == aLengths[i]){
						return true;
					}	
				}
				return false;
			}
			
			/**
			 * Check if string length is between specify lengths
			 * @param s
			 * @param iMaxChars
			 * @param iMinChars
			 * @return 
			 * 
			 */
			public static function betweenMinMaxLength(s:String, iMaxChars:Number, iMinChars:Number=0):Boolean{
					return !(s.length > iMaxChars || s.length < iMinChars);
			}
			
		}
}
