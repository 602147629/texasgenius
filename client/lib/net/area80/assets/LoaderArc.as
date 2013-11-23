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

package net.area80.assets
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.area80.display.ASprite;


	public class LoaderArc extends ASprite
	{
		[Embed(source = "fla/commonused.swf", symbol = "loaderarc")]
		protected var CLS:Class;
		protected var arc:Sprite;

		/**
		 * Speed of rotating
		 */
		public var rotationSpeed:Number = 8;

		public function LoaderArc()
		{
			super();
			arc = new CLS() as Sprite;
			addChild(arc);
		}

		override protected function construct(event:Event = null):void
		{
			super.construct(event);
			addEventListener(Event.ENTER_FRAME, update);

		}

		override public function dispose():void
		{
			super.dispose();
			removeEventListener(Event.ENTER_FRAME, update);

		}

		protected function update(e:Event):void
		{
			arc.rotation += rotationSpeed;
		}

	}
}