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

package net.area80.sitemanager.mvc.model.flow
{
	import net.area80.sitemanager.events.TransitionEvent;

	public class CrossFlow extends Flow
	{
		public function CrossFlow()
		{
			super();
		}
		override public function start():void
		{
			animationCount = 1;
			preloaderTransitionIn();
		}
		override protected function preloaderTransitionInComplete(e:TransitionEvent):void
		{
			super.preloaderTransitionInComplete(e);
			loadNewPage();
		}
		
		override protected function addPageToContainer():void
		{
			super.addPageToContainer();
			
			animationCount = 2;
			if(oldPage) animationCount++;
			
			if(crossFade) {
				preloaderTransitionOut();
				newPageTransitionIn();
				if(oldPage) oldPageTransitionOut();
				
			} else {
				preloaderTransitionOut();
			}
		}
		override protected function preloaderTransitionOutComplete(e:TransitionEvent):void
		{
			super.preloaderTransitionOutComplete(e);
			if(crossFade) {
				if(animationCount==0) step2();
			} else {
				newPageTransitionIn();
				if(oldPage) oldPageTransitionOut();
			}
		}
		
		override protected function newPageTransitionInComplete(e:TransitionEvent):void
		{
			super.newPageTransitionInComplete(e);
			if(animationCount==0) step2();
		}
		override protected function oldPageTransitionOutComplete(e:TransitionEvent):void
		{
			super.oldPageTransitionOutComplete(e);
			if(animationCount==0) step2();
		}
		
		
		protected function step2():void {
			flowComplete();
		}
		
	}
}