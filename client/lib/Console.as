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

package
{

	import flash.external.ExternalInterface;
	import org.osflash.signals.Signal;

	/**
	 * Dispatch message to available debugging console or just trace() it if TRACE_ENABLED is set.
	 * @author wissarut
	 *
	 */
	public class Console
	{
		public static var SignalTrace:Signal = new Signal(String);
		/**
		 * Enable tracing message to flash default trace() function
		 */
		public static var TRACE_ENABLED:Boolean = true;

		/**
		 * Set to true if want to use trace instead of console
		 */
		public static var USE_TRACE:Boolean = false;

		private static var isInit:Boolean = false;
		private static var _availability:Boolean = ExternalInterface.available;

		public function Console()
		{
		}

		private static function _initialize():Boolean
		{
			if (_availability) {
				try {
					_availability = ExternalInterface.call('function() { return (typeof console != "undefined"); }') as Boolean;
				} catch (e:Error) {
					_availability = false;
				}
			}
			return true;
		}
		private static var _initializer:Boolean = _initialize();

		/**
		 * Log String message to current browser in console window or simply trace it if console is unavailable.
		 * @param s message to be log on browser
		 *
		 */
		public static function log(s:*):void
		{
			var $message:String = "";
			if (s is String) {
				$message = s;
			} else if (s["toString"] is Function) {
				$message = s.toString();
			}

			if (_availability && _initializer) {
				try {
					if (!USE_TRACE) {
						ExternalInterface.call("console.log", $message);
					} else {
						doTrace($message);
					}
				} catch (e:Error) {
				}
			} else {
				doTrace($message);
			}
		}

		/**
		 * Log Error message to current browser in console window or simply trace it if console is unavailable.
		 * @param s String error message to be log on browser
		 *
		 */
		public static function error($message:String):void
		{
			if (_availability && _initializer) {
				try {
					if (!USE_TRACE) {
						ExternalInterface.call("console.error", $message);
					} else {
						doTrace($message);
					}
				} catch (e:Error) {
				}
			} else {
				doTrace($message);
			}
		}

		/**
		 * Log Object to current browser in console window or simply trace it if console is unavailable.
		 * @param o Object to be log on browser
		 *
		 */
		public static function dir($o:*):void
		{
			if (_availability && _initializer) {
				try {

					if (!USE_TRACE) {
						ExternalInterface.call("dir.error", $o);
					} else {
						doTrace($o);
					}
				} catch (e:Error) {
				}
			} else {
				doTrace($o);
			}
		}

		/**
		 * Just simple trace() if TRACE_ENABLED is set
		 * @param $message message to trace
		 *
		 */
		public static function doTrace($message:*):void
		{
			if (TRACE_ENABLED)
				trace($message);
			SignalTrace.dispatch($message);
		}

	}
}
