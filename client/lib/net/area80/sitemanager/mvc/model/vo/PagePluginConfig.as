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

package net.area80.sitemanager.mvc.model.vo
{
	import flash.display.Sprite;
	
	import net.area80.sitemanager.mvc.model.Page;
	import net.area80.sitemanager.mvc.model.enum.DepthStack;
	import net.area80.sitemanager.mvc.model.enum.TransitionFlow;
	import net.area80.sitemanager.mvc.plugins.PagePlugin;
	import net.area80.sitemanager.mvc.view.preloader.NoPreloader;

	public class PagePluginConfig
	{
		/**
		 * All page's content will be placed to this container
		 */
		public var container:Sprite;
		
		/**
		 * Preloader will be placed here
		 */
		public var preloadContainer:Sprite;
		
		/**
		 * Preloader Class musbe displayobject which implements IPreloader, Page plugin will instances this class internally.
		 */
		public var PreloaderClass:Class;
		
		/**
		 * Control how new page stacks on older page or just lay under it.
		 * Default is DepthStack.STACK
		 * @see net.area80.sitemanager.mvc.model.enum.DepthStack
		 */
		public var depthControl:String = DepthStack.STACK;
		
		/**
		 * Control how transition is going between pages and preloader.
		 * Default is PagePlugin.FLOW_OUT_PRELOAD_IN
		 * @see net.area80.sitemanager.mvc.model.enum.TransitionFlow
		 */
		public var transitionFlow:String = TransitionFlow.COMMON;
		
		/**
		 * If cross fade is enabled preloader's transition will be animated in the same time as page's transition.
		 */
		public var crossFadePreloader:Boolean = true;
		
		/**
		 * PagePluginConfigVO
		 * @see net.area80.sitemanager.mvc.plugins.PagePlugin
		 * 
		 * @param $container All page's content will be placed to this container
		 * @param $preloadContainer Preloader will be placed here
		 * @param $Preloader Preloader Class, Page Plugin will instances this class internally 
		 * 
		 */
		public function PagePluginConfig($container:Sprite, $preloadContainer:Sprite, $PreloaderClass:Class=null)
		{
			container = $container;
			preloadContainer = $preloadContainer;
			if(!$PreloaderClass) $PreloaderClass = NoPreloader;
			PreloaderClass = $PreloaderClass;
		}
		/**
		 * Override this to create your own page 
		 * @param $source
		 * @param $pageName
		 * @param $params
		 * @return 
		 * 
		 */
		public function createPageObject ($source:*, $pageName:String, $params:Object=null):Page {
			return new Page($source, $pageName, $params);
		}
	}
}