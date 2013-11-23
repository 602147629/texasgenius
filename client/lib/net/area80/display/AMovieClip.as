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

package net.area80.display
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * Act as a simple MovieClip which has dispose and construct behavior, extend to use it. 
	 * @author wissarut
	 * 
	 */
	public class AMovieClip extends MovieClip
	{
		protected var _disposeOnRemoved:Boolean = false;
		
		public function AMovieClip(disposeOnRemoved:Boolean = true)
		{
			super();
			
			_disposeOnRemoved = disposeOnRemoved;
			
			if(stage) {
				construct();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, construct);
			}
			tabEnabled = false;
			
		}
		
		public function set disposeOnRemoved (b:Boolean):void {
			_disposeOnRemoved = b;
		}
		public function get disposeOnRemoved ():Boolean {
			return _disposeOnRemoved;
			
		}
		/**
		 * Added to stage 
		 * @param event
		 * 
		 */
		protected function construct(event:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, construct);
			addEventListener(Event.REMOVED_FROM_STAGE, stageBlur);
		}
		
		
		/**
		 * Dispose will be called when removed from stage if disposeOnRemoved is set
		 * 
		 */
		public function dispose():void
		{
			//override this to take action
		}
		
		/**
		 * Removed from stage 
		 * @param event
		 * 
		 */
		protected function stageBlur (event:Event=null):void {
			addEventListener(Event.ADDED_TO_STAGE, construct);
			removeEventListener(Event.REMOVED_FROM_STAGE, stageBlur);
			if(disposeOnRemoved) dispose();
		}
	}
}