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

package net.area80.component.skinholder.button
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	import net.area80.utils.DrawingUtils;

	public class TintableButton extends AlphaButton
	{

		protected var source:Sprite;
		protected var _color:uint;
		protected var alphaTrans:Sprite;
		protected var clickArea:Sprite;
		
		public function TintableButton($source:Sprite)
		{
			source = $source;
			alphaTrans = new Sprite();
			alphaTrans.addChild(source);
			clickArea = DrawingUtils.getRectSprite(source.width,source.height);
			clickArea.alpha=0;
			addChildAt(clickArea,0);
			super(alphaTrans);
		}
		public function get color():uint {
			return _color;
		}
		public function set color($color:uint):void {
			_color = $color;
			var ct:ColorTransform = new ColorTransform();
			ct.color = $color;
			source.transform.colorTransform = ct;
		}
	}
}