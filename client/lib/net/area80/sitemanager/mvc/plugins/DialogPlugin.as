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
	import net.area80.sitemanager.mvc.command.Command;
	import net.area80.sitemanager.mvc.command.OpenDefaultDialogCommand;
	import net.area80.sitemanager.mvc.command.OpenDialogCommand;
	import net.area80.sitemanager.mvc.events.DialogEvent;
	import net.area80.sitemanager.mvc.model.Dialog;
	import net.area80.sitemanager.mvc.plugins.core.DisplayPlugin;
	import net.area80.sitemanager.mvc.view.swf.ShellSWF;

	public class DialogPlugin extends DisplayPlugin
	{
		
		public var dialogCount:uint = 1;
		protected var constructorByName:Dictionary;
		protected var dialogNames:Array;
	
		
		public function DialogPlugin($container:Sprite)
		{
			super($container);
			
		}
		protected function onOpenDialog ($cmd:OpenDialogCommand):void {
			var spr:Sprite = checkResource($cmd.dialog);
			if(spr) {
				var dialog:Dialog = composeDialog(spr,"",$cmd.params);
				initDialog(dialog);
			}
			
		}
		protected function checkResource ($resource:*):Sprite {
			if($resource is Sprite && $resource is IDialog) {
				return $resource as Sprite;
			} else {
				SiteManager.error(this,"Invalid dialog, dialog must be sprite which implements IDialog");
				return null;
			}
		}
		protected function onDefaultDialog ($cmd:OpenDefaultDialogCommand):void {
			var src:* = constructorByName[$cmd.dialogName];
			if(!src || !(src is Function)) {
				SiteManager.error(this,"Can't find default dialog name "+$cmd.dialogName);
			}
			var spr:Sprite = checkResource(src());
			if(spr) {
				var dialog:Dialog = composeDialog(spr,$cmd.dialogName,$cmd.params);
				initDialog(dialog);
			}
			
		}
		/**
		 * Add default dialog to the plugin. 
		 * @param $dialogName Name of the dialog, page's name used for OpenDefaultDialogCommand
		 * @param $source Function which return IDialog(DisplayObject) as dialog content.
		 * 
		 */
		public function addDefaultDialog ($dialogName:String, $source:Function):void {
			var test:* = $source();
			if(test && test is Sprite && test is IDialog) {
				if(!constructorByName) constructorByName = new Dictionary();
				if(!dialogNames) dialogNames = new Array;
				dialogNames.push($dialogName);
				constructorByName[$dialogName] = $source;
			} else {
				SiteManager.error(this,"Invalid dialog "+$dialogName+", dialog must be Sprite which implements IDialog");
			}
		}

		protected function initDialog ($dialog:Dialog):void {
			SiteManager.log(this+" Open dialog "+$dialog.name);
			$dialog.loadContent();
			container.addChild($dialog.content);
			
			$dialog.addEventListener(TransitionEvent.TRANSITION_IN_COMPLETE, dialogInHandler);
			freeze();
			$dialog.transitionIn();

		}
		
		protected function dialogInHandler($e:Event):void
		{

			var dialog:Dialog = $e.currentTarget as Dialog;
			dialog.addEventListener(DialogEvent.CLOSE_COMMAND, closeCommandHandler);
			unFreeze();
		}
		
		protected function closeCommandHandler($e:DialogEvent):void
		{
			freeze();
			var dialog:Dialog = $e.currentTarget as Dialog;
			dialog.addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE, removeDialog);
			dialog.transitionOut();
		}
		
		protected function removeDialog($e:TransitionEvent):void
		{
			var d:Dialog = $e.currentTarget as Dialog;
			try {
				container.removeChild(d.content);
			} catch (e:Error){}
			unFreeze();
		}
		protected function composeDialog ($source:Sprite, $name:String=null, $params:Object=null):Dialog {
			if(!$name || $name=="") {
				$name = "untitledialog_"+(dialogCount++);
			}
			var dialog:Dialog = new Dialog($source,$name,$params);
			return dialog;
		}
		
		override protected function commandBinding ():void
		{
			Command.bind(OpenDialogCommand, onOpenDialog);
			Command.bind(OpenDefaultDialogCommand, onDefaultDialog);
		}
		
	}
}