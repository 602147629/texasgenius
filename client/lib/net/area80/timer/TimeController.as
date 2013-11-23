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

package net.area80.timer
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * Controll delay of function calling
	 * @author wissarut
	 *
	 */
	public class TimeController
	{
		private static var count:uint = 0;
		private static var functionByID:Dictionary = new Dictionary();
		private static var timerByID:Dictionary = new Dictionary();

		/**
		 * Call the function once in specify time
		 * @param time seconds
		 * @param callBack
		 * @return ID of the call, you can stopDelayFunction or completeFunctionImmediately by use this ID
		 *
		 */
		public static function delayFucntion(time:Number, callBack:Function):uint
		{
			count++;
			var id:uint = count;
			var timer:Timer = new Timer(time*1000, 0);

			var handler:Function = function(e:TimerEvent = null):void {
				stopDelayFunction(id);
				try {
					callBack();
				} catch (e:Error) {}
			}
			timer.addEventListener(TimerEvent.TIMER, handler, false, 0, true);
			functionByID[id] = handler;
			timerByID[id] = timer;
			timer.start();
			return id;
		}

		public static function stopDelayFunction(id:uint):void
		{
			var handler:Function = functionByID[id];
			var timer:Timer = timerByID[id];
			if (handler!=null&&timer) {
				timer.stop();
				delete functionByID[id];
				delete timerByID[id];
			}
		}

		public static function completeFunctionImmediately(id:uint):void
		{
			var handler:Function = functionByID[id];
			var timer:Timer = timerByID[id];
			if (handler!=null&&timer) {
				try {
					handler();
				} catch (e:Error) {
				}
			}
		}
	}
}
