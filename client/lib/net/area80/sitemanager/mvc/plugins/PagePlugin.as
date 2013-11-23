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
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import net.area80.sitemanager.SiteManager;
	import net.area80.sitemanager.interfaces.view.IPreloader;
	import net.area80.sitemanager.mvc.command.ChangePageCommand;
	import net.area80.sitemanager.mvc.command.Command;
	import net.area80.sitemanager.mvc.command.PageChangedCommand;
	import net.area80.sitemanager.mvc.events.FlowEvent;
	import net.area80.sitemanager.mvc.model.Page;
	import net.area80.sitemanager.mvc.model.enum.TransitionFlow;
	import net.area80.sitemanager.mvc.model.flow.*;
	import net.area80.sitemanager.mvc.model.vo.PagePluginConfig;
	import net.area80.sitemanager.mvc.view.swf.ShellSWF;

	/**
	 * Default plugin of Area80 sitemanager framework. PagePlugin manages pages, preloader and how they transit between each page.
	 * @author wissarut
	 * 
	 */
	public class PagePlugin extends ShellPlugin
	{
		public static var instance:PagePlugin;
		
		protected var config:PagePluginConfig;
		
		protected var preloader:DisplayObject;
		
		protected var pageNames:Array;
		protected var constructorByName:Dictionary;
		
		protected var currentPage:Page;
		protected var newPage:Page;
		
		protected var currentCommand:ChangePageCommand;
		protected var stackCommand:ChangePageCommand;
		
		protected var animating:Boolean = false;
		
		public function get currentPageName():String {
			if(newPage) return newPage.name;
			return (currentPage) ? currentPage.name : "";
		}
		public function get allPageNames():Array {
			return pageNames;
		}
		
		/**
		 * Default plugin of Area80 sitemanager framework. PagePlugin manages pages, preloader and how they transit between each page.
		 * @param $config Configiration object
		 * 
		 */
		public function PagePlugin($config:PagePluginConfig)
		{
			super();
			if(instance) {
				SiteManager.error(this,"Can't construct, there must be only one PagePlugin");
			} else {
				instance = this;
			}
			config = $config;
			
			if(config.container==config.preloadContainer) {
				SiteManager.error(this,"Can't construct, preloader container class must be separated from container");
				return;
			}
			
			var check:* = new config.PreloaderClass();
			if(!(check is IPreloader) || !(check is DisplayObject)) {
				SiteManager.error(this,"Can't construct, preloader class must extends DisplayObject and implements IPreloader");
				return;
			}
			
		} 
		
		/**
		 * @internal 
		 * @param shell
		 * 
		 */
		override public function initializeShell(shell:ShellSWF):void
		{
			Command.bind(ChangePageCommand,onPageChange);
			Command.bind(PageChangedCommand,onPageChanged);
			super.initializeShell(shell); 
		}
		
		private function onPageChanged($cmd:PageChangedCommand):void
		{
			// TODO Auto Generated method stub
			
		}
		
		/**
		 * Add page to the plugin 
		 * @param $pageName Name of the page, this will displays in uri if swfaddress plugin is initialized and use as page's name for ChangePageCommand
		 * @param $source source can be URL(string) or Function which return IPage(DisplayObject) as page content.
		 * 
		 */
		public function addPage ($pageName:String, $source:*):void {
			if(!constructorByName) constructorByName = new Dictionary();
			if(!pageNames) pageNames = new Array;
			pageNames.push($pageName);
			constructorByName[$pageName] = $source;
		}
		

		/**
		 * Handle page change command 
		 * @param cmd
		 * 
		 */
		protected function onPageChange (cmd:ChangePageCommand):void {
			if(animating) {
				SiteManager.log(this+" Engine is animating, can't change page to \""+cmd.pageName+"\" just yet, stack page.");
				stackCommand = cmd;
				return;
			}
			
			SiteManager.log(this+" Page changing to \""+cmd.pageName+"\"."); 
			
			currentCommand = cmd;
			newPage  =  composePage(currentCommand);
			
			preloader = new config.PreloaderClass();
			config.preloadContainer.addChild(preloader);

			var flow:Flow;
			switch (config.transitionFlow) {
				case TransitionFlow.COMMON:
					flow = new CommonFlow();
					break;
				case TransitionFlow.FORWARD:
					flow = new ForwardFlow();
					break;
				case TransitionFlow.REVERSE:
					flow = new ReverseFlow();
					break;
				case TransitionFlow.CROSS:
					flow = new CrossFlow();
					break;
			}
			flow.addEventListener(FlowEvent.TRANSITION_COMPLETE, completeTransition);
			flow.initFlow(config.container, newPage, IPreloader(preloader), currentPage, config.depthControl, config.crossFadePreloader);
			
			freeze();
			
			flow.start();
		}
		
		/**
		 * Create Page object from command, this function will be overriden if you custom Page
		 * @param cmd
		 * @return 
		 * 
		 */
		protected function composePage (cmd:ChangePageCommand):Page {
			var constructor:* = constructorByName[cmd.pageName];
			if(!constructor) {
				SiteManager.error(this, "Can't find page named \""+cmd.pageName+"\".");
				return null;
			}
			var p:Page =config.createPageObject(constructor,cmd.pageName,cmd.params);
			return p;
		}
		
		protected function freeze ():void {
			animating = true;
			config.container.stage.mouseChildren = false;
		}
		
		protected function unFreeze ():void {
			animating = false;
			config.container.stage.mouseChildren = true;
		}
	
		protected function completeTransition (e:FlowEvent):void {
			currentPage = newPage;
			newPage = null;
			config.preloadContainer.removeChild(preloader);
			preloader = null;
			unFreeze();
			var cmd:PageChangedCommand = new PageChangedCommand(currentPageName);
			cmd.exec();
			doStackCommand();
		}
		
		/**
		 * Check if there is command stacking while page performing animation  
		 * 
		 */
		protected function doStackCommand ():void {
			
			if(stackCommand) {
				var stacking:ChangePageCommand = stackCommand;
				stackCommand = null;
				Console.dir(stacking);
				onPageChange(stacking);
			}
		}
		
		
	}
}