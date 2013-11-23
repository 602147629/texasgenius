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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import net.area80.sitemanager.SiteManager;
	import net.area80.sitemanager.events.TransitionEvent;
	import net.area80.sitemanager.interfaces.view.IDialog;
	import net.area80.sitemanager.mvc.command.AlertCommand;
	import net.area80.sitemanager.mvc.command.Command;
	import net.area80.sitemanager.mvc.command.ConfirmCommand;
	import net.area80.sitemanager.mvc.events.DialogEvent;
	import net.area80.sitemanager.mvc.model.Dialog;
	import net.area80.sitemanager.mvc.model.vo.AlertMessageVO;
	import net.area80.sitemanager.mvc.model.vo.ConfirmMessageVO;
	import net.area80.sitemanager.mvc.view.swf.ShellSWF;
	
	public class AlertPlugin extends DialogPlugin
	{
	//	protected var container:Sprite;
	//	public var dialogCount:uint = 1;
		//protected var constructorByName:Dictionary;
	//	protected var dialogNames:Array;
		
		protected var inAnimation:uint = 0;
		protected var outAnimation:uint = 0;
		
		public function AlertPlugin($container:Sprite)
		{
			super($container);
			
		}
		
	
		protected function onAlertDialog ($cmd:AlertCommand):void {
			openDialog($cmd.message);
		}
		protected function onConfirmDialog ($cmd:ConfirmCommand):void {
			openDialog($cmd.message);
		}
		protected function openDialog ($message:AlertMessageVO):void {
			var dialogName:String;
			if($message is AlertMessageVO) {
				dialogName = "alert";
			} else if ($message is ConfirmMessageVO) {
				dialogName = "confirm";
			}
			var src:* = constructorByName[dialogName];
			if(!src) {
				SiteManager.error(this,"Can't find "+dialogName+" dialog");
			}
			var spr:Sprite = checkResource(src());
			if(spr) {
				var dialog:Dialog = new Dialog(spr,dialogName,$message);
				initDialog(dialog);
			}
			
		}
		
		/**
		 * Add alert dialog to the plugin. 
		 * @param $source Function which return IDialog(DisplayObject) as alert dialog content.
		 * 
		 */
		public function addAlertDialog ($source:Function):void {
			super.addDefaultDialog("alert",$source);
		}
		
		
		
		/**
		 * Add comfirm dialog to the plugin. 
		 * @param $source Function which return IDialog(DisplayObject) as confirm dialog content.
		 * 
		 */
		public function addComfirmDialog ($source:Function):void {
			super.addDefaultDialog("comfirm",$source);
		}

		
		/**
		 * NOT USE THIS FUNCTION IN THIS CLASS 
		 * @param $dialogName
		 * @param $source
		 * 
		 */
		override public function addDefaultDialog($dialogName:String, $source:Function):void
		{
			SiteManager.error(this, "Dialog ["+$dialogName+"] can't be created, use addAlertDialog or addComfirmDialog in stead of addDefaultDialog");
		}
		
		override protected function commandBinding ():void
		{
			Command.bind(AlertCommand, onAlertDialog);
			Command.bind(ConfirmCommand, onConfirmDialog);
		}
		
	}
}