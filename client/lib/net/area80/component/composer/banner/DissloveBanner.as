package net.area80.component.composer.banner
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import gs.TweenLite;

	public class DissloveBanner
	{
		protected var _pointer:int = 0;
		protected var fadeTime:Number = 0;
		protected var displayTime:Number = 0;
		protected var items:Vector.<Sprite>;
		protected var displayTimeByPointer:Array;
		
		public function DissloveBanner($displayTime:Number = 1, $fadeTime:Number = .5)
		{
		
			displayTime = $displayTime;
			fadeTime = $fadeTime;
			_pointer = 0;

		}
		public function addItem ($item:Sprite, $forceTime:Number = 0):void {
			if(!items) 	items = new Vector.<Sprite>;
			if(!displayTimeByPointer) 	displayTimeByPointer = new Array();
			items.push($item);
			var t:Number = ($forceTime!=0) ? $forceTime : displayTime;
			displayTimeByPointer.push(t);
			
			if(items.length==1){
				$item.alpha = 1;
				$item.visible = true;
			} else {
				$item.alpha = 0;
				$item.visible = false;
			}
		}
		
		protected function get pointer():int {return _pointer}
		protected function set pointer(p:int):void {
			if(p>items.length-1) {
				_pointer = 0;
			} else if (p<0) {
				_pointer = items.length-1;
			} else {
				_pointer = p;
			}
		}

		public function get currentID ():uint {
			return pointer;
		}
		public function start ():void {
			nextBanner();
		}
		public function stop ():void {
			for(var i:uint=0;i<items.length;i++) {
				if(items[i]) TweenLite.killTweensOf(items[i]);
			}
		}
		protected function get currentItem ():Sprite {
			return items[pointer];
		}
		protected function get nextItem ():Sprite {
			return (pointer+1>=items.length) ? items[0] : items[pointer];
		}
		protected function get prevItem ():Sprite {
			return (pointer-1<0) ? items[items.length-1] : items[pointer];
		}
		protected function nextBanner ():void {
			if(currentItem) {
				if(currentItem is MovieClip) MovieClip(currentItem).gotoAndPlay(1);
				var t:Number = displayTimeByPointer[pointer];
				TweenLite.to(currentItem,fadeTime,{delay:t,autoAlpha:0,onComplete:fadeUp});
				
			} else {
				stop();
			}
			
		}
		protected function fadeUp ():void {
			pointer++;
			if(currentItem) {
				TweenLite.to(currentItem,fadeTime,{autoAlpha:1,onComplete:nextBanner});
			} else {
				stop();
			}
		}
	}
}