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

package net.area80.sitemanager.mvc.view.swf
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import net.area80.sitemanager.SiteManager;
	import net.area80.sitemanager.mvc.events.PluginEvent;
	import net.area80.sitemanager.mvc.events.ShellEvent;
	import net.area80.sitemanager.mvc.plugins.ShellPlugin;
	
	/**
	 * Dispatchs when plugin is initialized.
	 * @eventType net.area80.sitemanager.mvc.events.ShellEvent.PLUGIN_READY
	 */
	[Event(name="pluginReady", type="net.area80.sitemanager.mvc.events.ShellEvent")]
	
	/**
	 * Dispatchs when shell is ready to use.
	 * @eventType net.area80.sitemanager.mvc.events.ShellEvent.SHELL_READY
	 */
	[Event(name="shellReady", type="net.area80.sitemanager.mvc.events.ShellEvent")]
	
	/**
	 * Dispatchs just before shell does initialize plugins.
	 * @eventType net.area80.sitemanager.mvc.events.ShellEvent.BEFORE_INIT_PLUGIN
	 */
	[Event(name="beforeInitPlugin", type="net.area80.sitemanager.mvc.events.ShellEvent")]

	/**
	 * Main ShellSWF 
	 * Extend this class to start using framework. Please note that stage is aligned to TOP_LEFT and scaleMode is set to NO_SCALE. 
	 * For usage of this class please see template package.
	 * @author wissarut
	 * 
	 */
	public class ShellSWF extends Sprite
	{
		
		protected var plugins:Vector.<ShellPlugin>;
		protected var pluginByName:Dictionary;

		

		public function ShellSWF()
		{
			if(stage) {
				initShell();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, initShell);
			}
		}
		
		/**
		 * This function will be caled internally after all plugins are initialized. 
		 * 
		 */
		protected function shellReady ():void {
			dispatchEvent(new ShellEvent(ShellEvent.SHELL_READY));
		}
		
		/**
		 * Override this method to add plugins to framework
		 * 
		 */
		protected function addPlugins ():void {
			throw SiteManager.error(this,"Override addPlugins Method First!");
		}
		
		/**
		 * Do add plugin 
		 * @param $p
		 * 
		 */
		protected function addShellPlugin ($p:ShellPlugin):void {
			if(!pluginByName) pluginByName = new Dictionary();
			if(!pluginByName[getQualifiedClassName($p)]) {
				pluginByName[getQualifiedClassName($p)] = $p;
				if(!plugins) plugins = new Vector.<ShellPlugin>;
				$p.name = getQualifiedClassName($p);
				$p.addEventListener(PluginEvent.READY, checkPluginsStatus);
				plugins.push($p);
				SiteManager.log("[ShellSWF] Plug in added "+$p);
			} else {
				SiteManager.error(this, "Plugin duplicated.");
			}
		}
		
		
		private function initShell (e:Event=null):void {
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addPlugins();
			dispatchEvent(new ShellEvent(ShellEvent.BEFORE_INIT_PLUGIN));
			initPlugins();
		}
		
		private function initPlugins ():void {
			if(plugins) {
				for(var i:uint=0;i<plugins.length;i++) {
					plugins[i].initializeShell(this);
				}
			}
		}
		/**
		 * internally called when each plugin dispatchs READY event, if all events are initialized this function dispatchs PLUGIN_READY event 
		 * @param $e
		 * 
		 */
		private function checkPluginsStatus ($e:PluginEvent):void {
			var $plugin:ShellPlugin = $e.currentTarget as ShellPlugin;
			SiteManager.log("[ShellSWF] Plug in initialized "+$plugin);
			var allReady:Boolean = true;
			if(plugins) {
				for(var i:uint=0;i<plugins.length;i++) {
					
					if(!plugins[i].plugInIsReady) allReady = false;
				}
			}
			if(allReady) {
				dispatchEvent(new ShellEvent(ShellEvent.PLUGIN_READY));			
				shellReady();
			}
		}
		
		
	}
}