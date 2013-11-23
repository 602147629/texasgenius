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

package net.area80.sitemanager.mvc.model
{
	import net.area80.sitemanager.interfaces.commandmap.ISWFAddressPageCommandMap;
	import net.area80.sitemanager.interfaces.view.ISWFAddressPage;
	import net.area80.sitemanager.mvc.events.SWFAddressPageEvent;
	
	/**
	 * Dispatchs when content needs to update SWFAddreess value.
	 */
	[Event(name="valueChange", type="net.area80.sitemanager.mvc.events.SWFAddressPageEvent")]
	
	public class SWFAddressPage extends Page implements ISWFAddressPageCommandMap
	{
		
		protected var _currentSWFAddressValue:Array;
		
		public function SWFAddressPage($source:*, $name:String, $params:Object=null)
		{
			super($source ,$name, $params); 
		}
		protected function compareValue ($newvalues:Array):Boolean {
			var currentValue:Array = _currentSWFAddressValue; 
			var newValue:Array = $newvalues;
			if(currentValue==null && newValue==null) return true;
			if(currentValue==null || newValue==null) return false;
			
			var sameArray:Boolean = true;
			
			if(currentValue.length==newValue.length) {
				for(var i:uint=0;i<newValue.length;i++) {
					if(currentValue[i]!=newValue[i]) {
						return false;
					}
				}
			} else {
				return false;
			}
			return true;
		}
		public function onSWFAddressValueChange (value:Array):void {
			if(!compareValue(value)) {
				_currentSWFAddressValue = value;
				try {
				// If content doesn't implement ISWFAddressPage
				ISWFAddressPage(content).onSWFAddressValueChange(value);
				} catch (e:Error){}
			}
		}
		public function get currentSWFAddressValue ():Array {	return _currentSWFAddressValue;  }
		/**
		 * Page will calls this function to update SWFAddress value 
		 * @param $values
		 * 
		 */
		public function updateSWFAddressValue($values:Array):void
		{
			var $val:Array = [name];
			dispatchEvent(new SWFAddressPageEvent(SWFAddressPageEvent.VALUE_CHANGE, $val.concat($values)));
		}
	}
}