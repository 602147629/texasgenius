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
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import net.area80.sitemanager.SiteManager;
	import net.area80.sitemanager.events.TransitionEvent;
	import net.area80.sitemanager.interfaces.commandmap.ICommandMap;
	import net.area80.sitemanager.interfaces.commandmap.IPageCommandMap;
	import net.area80.sitemanager.interfaces.view.IPage;
	import net.area80.sitemanager.interfaces.view.ITransitionalDisplay;
	import net.area80.sitemanager.mvc.command.AlertCommand;
	import net.area80.sitemanager.mvc.command.ChangePageCommand;
	import net.area80.sitemanager.mvc.command.ConfirmCommand;
	import net.area80.sitemanager.mvc.command.FreezeCommand;
	import net.area80.sitemanager.mvc.command.OpenDefaultDialogCommand;
	import net.area80.sitemanager.mvc.command.OpenDialogCommand;
	import net.area80.sitemanager.mvc.command.TrackCommand;
	import net.area80.sitemanager.mvc.events.PageEvent;
	import net.area80.sitemanager.mvc.model.vo.AlertMessageVO;
	import net.area80.sitemanager.mvc.model.vo.ConfirmMessageVO;
	
	/**
	 * Dispaths after transitionIn() completes. 
	 */
	[Event(name="transitionInCompleted", type="net.area80.sitemanager.events.TransitionEvent")]
	
	/**
	 * Dispaths after transitionOut() completes. 
	 */
	[Event(name="transitionOutCompleted", type="net.area80.sitemanager.events.TransitionEvent")]

	public class CommandMap extends EventDispatcher implements ITransitionalDisplay, ICommandMap
	{
		//GETTER
		protected var _content:Sprite;
		public function get content ():Sprite 		{		return _content;			}
		
		protected var _name:String;
		public function get name ():String 			{		return _name;				}
		
		protected var _params:Object;
		protected var source:*;
		
		public function CommandMap($source:*,$name:String, $params:Object=null)
		{
			_params = $params;
			_name = $name;
			source = $source;
		}
		
		protected function dispose (e:Event):void {
			removeEventListener(e.type, dispose);
			if(content) {
				if(content is MovieClip) {
					try{
						MovieClip(content).stop();
					} catch (e:Error){}
				}
			}
			
		}
		
		public function loadContent ():void {
			if(source is Sprite) {
				initContent(source);
			} else if(source is Function) {
				try { 
					initContent(source() as Sprite);
				} catch (e:Error) {
					error("source function must return sprite");
				}
			} else {
				error("source must be sprite");
			}
		}
		
		protected function error (msg:String):void {
			SiteManager.error(this, msg);
		}
		
		
		protected function initContent ($content:Sprite):void {
			_content = $content;
			ITransitionalDisplay(content).addEventListener(TransitionEvent.TRANSITION_IN_COMPLETE, transitionInComplete);
			ITransitionalDisplay(content).addEventListener(TransitionEvent.TRANSITION_OUT_COMPLETE, transitionOutComplete);
			mapContentToCommand();
			initTrack();
			content.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			dispatchEvent(new PageEvent(PageEvent.CONTENT_INIT)); 
		}
		/**
		 * Override this function to map command to content 
		 * 
		 */
		protected function mapContentToCommand ():void { 
				try {
				content["commandMap"] = this;
				} catch (e:Error){
				SiteManager.log(this+" Can't bind commandMap to the object.");
				}
		
		}
		protected function initTrack ():void {
			track("");
		}
		
		protected function transitionOutComplete(event:Event):void	{		dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_OUT_COMPLETE));		}
		protected function transitionInComplete(event:Event):void	{		dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_IN_COMPLETE));		}	
		
		
		//FORWARD TO IPAGE
		
		public function transitionIn():void 		{			ITransitionalDisplay(content).transitionIn();			}
		public function transitionOut():void		{			ITransitionalDisplay(content).transitionOut();			}
		
		
		//COMMAND
		
		public function alert($msg:String, $title:String="", $okBtnName:String="ok", $okCallback:Function=null):void
		{
			var vo:AlertMessageVO = new AlertMessageVO($msg, $title, $okBtnName, $okCallback);
			var cmd:AlertCommand = new AlertCommand(vo);
			cmd.exec();
			
		}
		
		public function confirm($msg:String, $title:String="", $okBtnName:String="ok", $cancelBtnName:String="cancel", $okCallback:Function=null, $cancelCallback:Function=null):void
		{
			var vo:ConfirmMessageVO = new ConfirmMessageVO($msg, $title, $okBtnName, $cancelBtnName, $okCallback, $cancelCallback);
			var cmd:ConfirmCommand = new ConfirmCommand(vo);
			cmd.exec();
		}
		
		public function get params():Object	{		return _params;			}
		
		public function openDefaultDialog($name:String, $params:Object=null):void
		{
			var cmd:OpenDefaultDialogCommand = new OpenDefaultDialogCommand($name,$params);
			cmd.exec();
		}
		
		public function openDialog($source:Sprite, $name:String="", $params:Object=null):void
		{
			var cmd:OpenDialogCommand = new OpenDialogCommand($source,$name,$params);
			cmd.exec();
		}
		
		public function track($activity:String):void
		{
			var cmd:TrackCommand = new TrackCommand(name, $activity);
			cmd.exec();
			
		}
		
		public function freeze($fadeDuration:Number=0):void
		{
			var cmd:FreezeCommand = new FreezeCommand(true, $fadeDuration);
			cmd.exec();
			
		}
		public function unFreeze($fadeDuration:Number=0):void
		{
			var cmd:FreezeCommand = new FreezeCommand(false, $fadeDuration);
			cmd.exec();
		}
	}
}