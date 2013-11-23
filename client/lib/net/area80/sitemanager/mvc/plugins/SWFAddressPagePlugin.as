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

package net.area80.sitemanager.mvc.plugins
{
	import com.adobe.serialization.adobejson.AdobeJSON;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.area80.sitemanager.SiteManager;
	import net.area80.sitemanager.mvc.command.ChangePageCommand;
	import net.area80.sitemanager.mvc.command.Command;
	import net.area80.sitemanager.mvc.events.SWFAddressPageEvent;
	import net.area80.sitemanager.mvc.model.Page;
	import net.area80.sitemanager.mvc.model.SWFAddressPage;
	import net.area80.sitemanager.mvc.model.vo.PagePluginConfig;
	import net.area80.sitemanager.mvc.view.swf.ShellSWF;

	/**
	 * SWFAddress competible page plugin
	 * @author wissarut
	 * 
	 */
	public class SWFAddressPagePlugin extends PagePlugin
	{
		protected var shellToInit:ShellSWF;
		protected var defaultPage:String;
		protected var _history:Boolean;
		
		/**
		 * SWFAddress competible page plugin 
		 * @param $config 
		 * @param $historyEnabled If enabled, user can use browser navigation history to control pages
		 * 
		 */
		public function SWFAddressPagePlugin($config:PagePluginConfig, $historyEnabled:Boolean = false)
		{
			_history = $historyEnabled;
			super($config);
		}
		public function initPage ($defaultPage:String):void {
			if(!constructorByName[$defaultPage]) {
				throw new Error("Default page  \""+$defaultPage+"\" is unavailable.");
				return;
			}
			defaultPage = $defaultPage;
			var val:Array = getCurrentValues();
			if(!val || !constructorByName[val[0]])  val = [defaultPage];
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onAddressChange);
			SWFAddress.setValue(val.join("/"));
		}
		
		override protected function onPageChange(cmd:ChangePageCommand):void
		{
			if(animating) {
				SiteManager.log(this+" Engine is animating, can't change page to \""+cmd.pageName+"\" just yet, stack page.");
				stackCommand = cmd;
				return;
			}
			if(cmd.pageName==currentPageName) {
				//If it is the same page, just update its params
				updateCurrentParams();
			} else {
				//If new page
				SWFAddress.setValue(cmd.pageName);
			}
		}

		
		protected function updateCurrentParams ():void {
			if(currentPage) SWFAddressPage(currentPage).onSWFAddressValueChange(getCurrentValuesWithoutPageName());
		}
		
		override public function initializeShell(shell:ShellSWF):void
		{
			shellToInit = shell;
			SWFAddress.onInit = swfAddressInit;
		}

		/**
		 * @internal SWFAddress SWFAddressEvent.CHANGE handler 
		 * @param e
		 * 
		 */
		protected function onAddressChange (e:SWFAddressEvent):void {

			var cmd:ChangePageCommand = composeCommand(getCurrentValues());
		
			if(pageIsAvialable(cmd)) {
				if(cmd.pageName==currentPageName) {
					updateCurrentParams();
				} else {
					super.onPageChange(cmd);
				}
			}
		}
		/**
		 * Check if page is available 
		 * @param $cmd
		 * @return 
		 * 
		 */
		protected function pageIsAvialable ($cmd:ChangePageCommand):Boolean {
			return ($cmd && constructorByName[$cmd.pageName]) ? true : false;
		}
		/**
		 * Create command from swfaddress's value (array) 
		 * @param $swfvalues
		 * @return 
		 * 
		 */
		protected function composeCommand ($swfvalues:Array):ChangePageCommand {
			return ($swfvalues && $swfvalues.length>0) ? new ChangePageCommand($swfvalues[0]) : null;
		}
		/**
		 * Get current swfaddress's value in array 
		 * @return 
		 * 
		 */
		protected function getCurrentValues ():Array {
			var currentVal:Array;
			if(SWFAddress.getValue() && SWFAddress.getValue()!="") {
				currentVal = SWFAddress.getValue().split("/");
			}
			if(currentVal) {
				var returnAry:Array = new Array();
				for(var i:uint=0;i<currentVal.length;i++) {
					if(currentVal[i] && currentVal[i]!="") returnAry.push(currentVal[i]);
				}
				return (returnAry.length>0) ? returnAry : null;
			}
			return null;
		}
		/**
		 * Get current swfaddress's value in array without page's name 
		 * @return 
		 * 
		 */
		protected function getCurrentValuesWithoutPageName ():Array {
			var val:Array = getCurrentValues();
			if(val && val.length>1) {
				return val.slice(1);
			} else {
				return null;
			}
		}
		
		/**
		 * @internal swfaddress init 
		 * 
		 */
		protected function swfAddressInit ():void {
			SWFAddress.setHistory(_history);
			super.initializeShell(shellToInit); 
		}
		
		
		override protected function composePage(cmd:ChangePageCommand):Page
		{
			var constructor:* = constructorByName[cmd.pageName];
			if(!constructor) {
				SiteManager.error(this, "Can't find page named \""+cmd.pageName+"\".");
				return null;
			}
			var p:SWFAddressPage = config.createPageObject(constructor, cmd.pageName, cmd.params) as SWFAddressPage;
			p.addEventListener(SWFAddressPageEvent.VALUE_CHANGE, pageChangeValueHandler);
			p.onSWFAddressValueChange(getCurrentValuesWithoutPageName());
			
			return p;
		}
		
		/**
		 * Get change value dispatched from page's content 
		 * @param $e
		 * 
		 */
		protected function pageChangeValueHandler($e:SWFAddressPageEvent):void
		{
			
			if($e.values && $e.values.length>1) {
				
				var currentValue:Array = getCurrentValues(); 
				var newValue:Array = $e.values;
				var sameArray:Boolean = true;
				if(currentValue && currentValue.length==newValue.length) {
					for(var i:uint=0;i<newValue.length;i++) {
						if(currentValue[i]!=newValue[i]) {
							sameArray = false;
							break;
						}
					}
				} else {
					sameArray = false;
				}
				
				if(!sameArray) SWFAddress.setValue(newValue.join("/"));
			}
		}
		
	}
}