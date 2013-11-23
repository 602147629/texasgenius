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

package net.area80.debug
{

	import flash.utils.describeType;

	public class TraceObject
	{
		/**
		 * Specify how deep level the object will be read (prevent crash from nested object)
		 */
		public static var DIG_DEPTH:uint = 4;

		private static function bracesQuote(o:Object):String
		{
			var typeXML:XML = describeType(o);
			var s:String = "" + String(typeXML.@name).split("::").join(".") + " {";
			var isFirst:Boolean = true;
			for each (var node:XML in typeXML.variable) {
				s += ((!isFirst) ? ", " : "") + [node.@name] + ":\"" + String(o[node.@name]).split('""').join('\\"') + "\"";
				if (isFirst)
					isFirst = false;
			}
			s += "}"
			return s;
		}

		/**
		 * Read Object value string format
		 * @param o
		 * @param digDepth how deep level the object will be read (prevent crash from nested object)
		 * @param currentPos internal use only for looping
		 * @return
		 *
		 */
		public static function easyToRead(o:Object, digDepth:uint = 4, currentPos:uint = 0):String
		{
			if (currentPos >= digDepth)
				return "...";
			var endstatement:String = ",";
			if (o != null) {
				var i:uint;
				var count:uint = 0;
				var node:XML;
				var tab:String = "";
				var typeXML:XML = describeType(o);

				if (typeXML == "" && o.toString() == "[object Object]") {
					for (i = 0; i < currentPos; i++) {
						tab += "\t";
					}
					var str:String = "Object {";
					for (var item:* in o) {
						if (count == 0)
							str += "\n";
						if (count > 0) {
							str += endstatement + "\n";
						}

						str += tab + "\t" + item + " : " + easyToRead(o[item], digDepth, currentPos + 1);
						count++;
					}
					str += ((count > 0) ? "\n" + tab : '') + "}";
					return str;
				}

				if (typeXML) {
					var type:String = String(typeXML.@name).split("::").join(".");
					var base:String = String(typeXML.@base).split("::").join(".");

					if (type.toLowerCase() == "string")
						return String("\"" + o + "\"");
					if (type.toLowerCase() == "array" || type.toLowerCase().indexOf("__as3__.vec.vector") == 0)
						return easyToReadArray(o, digDepth, currentPos);
					if (type.toLowerCase() == "int" || type.toLowerCase() == "uint" || type.toLowerCase() == "number")
						return String(o);
					tab = "";
					for (i = 0; i < currentPos; i++) {
						tab += "\t";
					}
					currentPos = currentPos + 1;

					var s:String = type + " {";
					var obj:Object;
					count = 0;
					if (type == "flash.display.Loader")
						return type + " {}";
					if (type != "builtin.as$0.MethodClosure") {
						s = type + " {";
						for each (node in typeXML.variable) {
							if (count == 0)
								s += "\n";
							if (count > 0) {
								s += endstatement + "\n";
							}
							try {
								obj = o[node.@name];
								s += tab + "\t" + node.@name + " : " + easyToRead(o[node.@name], digDepth, currentPos);
							} catch (e:Error) {
								s += tab + "\t" + node.@name + " : <null>";
							}
							count++;

						}
						for each (node in typeXML.accessor) {
							if (count == 0)
								s += "\n";
							if (count > 0) {
								s += endstatement + "\n";
							}
							try {
								obj = o[node.@name];
								s += tab + "\t" + node.@name + " : " + easyToRead(o[node.@name], digDepth, currentPos);
							} catch (e:Error) {
								s += tab + "\t" + node.@name + " : <null>";
							}
							count++;

						}
						for each (node in typeXML.method) {
							if (count == 0)
								s += "\n";
							if (count > 0) {
								s += endstatement + "\n";
							}
							try {
								obj = o[node.@name];
								s += tab + "\t" + node.@name + " : " + easyToRead(o[node.@name], digDepth, currentPos);
							} catch (e:Error) {
								s += tab + "\t" + node.@name + " : <null>";
							}
							count++;

						}
					} else {
						s = "Function (" + o["length"] + ") {";
					}
					s += ((count > 0) ? "\n" + tab : '') + "}";
					return s;
				} else {
					return String(o);
				}
			} else {

				return "null";
			}
		}

		private static function easyToReadArray(o:Object, digDepth:uint = 4, currentPos:uint = 0):String
		{
			if (o.hasOwnProperty("length")) {
				var tab:String = "";
				var i:uint = 0;
				for (i = 0; i < currentPos; i++) {
					tab += "\t";
				}
				currentPos = currentPos + 1;
				var type:String = "Vector";
				if (o is Array)
					type = "Array";
				var s:String = type + " [";
				for (i = 0; i < o.length; i++) {
					if (i == 0)
						s += "\n";
					if (i > 0) {
						s += ",\n";
					}
					s += tab + "\t" + easyToRead(o[i], digDepth, currentPos);
				}
				s += ((i > 0) ? "\n" + tab : '') + "]";
				return s;
			} else {
				throw new Error("not array or vector");
				return null;
			}
		}

	}
}
