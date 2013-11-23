/*
Copyright © 2008-2011, Area80 Co.,Ltd.
All rights reserved.

Facebook: http://www.fb.com/Area80/
Website: http://www.area80.net/
Docs: http://www.area80.net/sitemanager/


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

package net.area80.sitemanager
{
	import flash.utils.getTimer;

	/**
	 * Area80's SiteManager use MVC (Model, View, Command) pattern to create framework with additional of plugins and services package to enchance capability and flexibly of framwork.
	 *  
	 * @author wissarut
	 * 
	 */
	public class SiteManager
	{
			
		/**
		 * If set VERBOSE, all system message will be display on debugging console. 
		 */
		public static var VERBOSE:Boolean = true;
		/**
		 * If set to true, current time will display to console along with message.
		 */
		public static var SHOWTIME:Boolean = true;
		public static var VERSION:String = "1.2 build 19.Jan.2012";
		public static var SKIP_FRAMEWORK_ERROR:Boolean = true;
		
		private static var _displayed:Boolean = false;
		public function SiteManager()
		{
		}
		
		private static function getTime ():String {
			return (SHOWTIME) ? "["+getTimer()+"]" : "";
		}
		/**
		 * Show system message on debugging console 
		 * @param $message message to display
		 * 
		 */
		public static function log ($message:String):void {
			if(!_displayed) {
				_displayed = true;
				if(VERBOSE) Console.log("[80]"+getTime()+" Area80 Sitemanager version "+VERSION);
			}
			if(VERBOSE) Console.log("[80]"+getTime()+" "+$message); 
		}
		/**
		 * Show error message on debugging console or throw new Error if SKIP_FRAMEWORK_ERROR is disable.
		 * @param $currentObject object which dispatchs the error
		 * @param $message Error message to display
		 * 
		 */
		public static function error ($currentObject:*, $message:String):void {
			if(!_displayed) {
				_displayed = true;
				if(VERBOSE) Console.log("[80]"+getTime()+" Area80 Sitemanager version "+VERSION);
			}
			if(VERBOSE) Console.error("[80][ERROR]"+getTime()+" "+$currentObject+" "+$message);
			
			if(!SKIP_FRAMEWORK_ERROR) {
				throw new Error($currentObject+" "+$message);
			}
		}
	}
}