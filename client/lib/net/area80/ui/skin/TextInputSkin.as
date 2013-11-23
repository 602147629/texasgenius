package net.area80.ui.skin
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import org.osflash.signals.Signal;

	
	public class TextInputSkin extends Sprite
	{
		public var inputText:TextField;
		public var defaultText:TextField;
		public var textBg:MovieClip;
		public var clearBtn:MovieClip;
		public function TextInputSkin()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void
		{			
			trace("____addChild");
			removeEventListener(Event.ADDED_TO_STAGE,init);
			textBg.gotoAndStop(1);
			if(clearBtn){
				clearBtn.gotoAndStop(1);
			}
		}
	}
}