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

package net.area80.display.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import net.area80.utils.LoaderUtils;
	
	/**
	 * Load image (jpg,png,gif) in bynary format to container and fill it in a box.
	 * 
	 * @usage
	 * 
	 * <code>
	 * var imagebox:ImageBox = new ImageBox("image.jpg",100,100);//Content will be loaded and scaled to fit a 100x100 box. However, If content is smaller than the box it will not scaled up.
	 * //init listeners
	 * imagebox.addEventListener(Event.COMPLETE, completeHandler);
	 * imagebox.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	 * imagebox.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
	 * //or use signal to get all event
	 * ploader.SIGNAL_EVENT.add(someFunction);
	 * //start load
	 * imagebox.load();
	 * </code>
	 * 
	 * @author wissarut
	 * @version 2.0
	 * 
	 */
	public class ImageBox extends PhotoLoader
	{
		protected var fillBox:Boolean;
		protected var clickArea:Sprite;
		protected var masker:Sprite; 
		
		/**
		 * Load image to specify box size 
		 * @param $path can be "" if you want to set a bitmapdata to it with setContent
		 * @param $boxw	Width of the box.
		 * @param $boxh Height of the box.
		 * @param $fillBox Fill the box with content.(Content may be scaled up, if it is smaller than the box);
		 * 
		 */
		public function ImageBox($path:String,$boxw:uint,$boxh:uint,$fillBox:Boolean=false)
		{
		
			fillBox = $fillBox;
			generateClickArea();
			clickArea.width = $boxw;
			clickArea.height = $boxh; 
			super($path, $boxw, $boxh);
			
		}
		
		public override function get width ():Number {
			return w;
		}
		public override function set width ($w:Number):void {
			w = $w;
			composeContent();
		}
		public override function get height ():Number {
			return h;
		}
		public override function set height ($h:Number):void {
			h = $h;
			composeContent();
		}
		protected override function composeContent ():void {

			if(content){
				content.scaleX = content.scaleY = 1;
				var sx:Number = w/content.width;
				var sy:Number = h/content.height;
				_scale = (!fillBox) ? Math.min(sx,sy) :  Math.max(sx,sy);
				if(!fillBox && _scale >1) _scale = 1;
				content.scaleX = content.scaleY = _scale;

				content.x = (w-content.width)*0.5;
				content.y = (h-content.height)*0.5;
				
				maskContent(w,h);
			}
			clickArea.width = w;
			clickArea.height = h;
			
		}
		protected function generateClickArea ():void {
			clickArea = new Sprite();
			clickArea.graphics.beginFill(0x0000);
			clickArea.graphics.drawRect(0,0,100,100);
			addChild(clickArea);
			clickArea.alpha = 0;
		}
		protected function maskContent ($width:uint, $height:uint):void {
			if(!masker) {
				masker = new Sprite();
				masker.graphics.beginFill(0x0000);
				masker.graphics.drawRect(0,0,w,h);
				addChild(masker);
				content.mask = masker;
			} else {
				masker.width = $width;
				masker.height = $height;
			}
		}
	
	}
}