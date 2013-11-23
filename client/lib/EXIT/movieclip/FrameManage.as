package EXIT.movieclip
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class FrameManage
	{
		private static var frame:uint;
		public static function reverseFrameTo( $mc:MovieClip , $frame:uint=1 ):void
		{
			frame = $frame;
			$mc.addEventListener(Event.ENTER_FRAME , reverseEnterFrame);
		}
		
		public static function stopReverse( $mc:MovieClip ):void
		{
			$mc.removeEventListener(Event.ENTER_FRAME , reverseEnterFrame);
		}
		
		private static function reverseEnterFrame(e:Event):void
		{
			var mc :MovieClip = MovieClip(e.currentTarget);
			if(mc.currentFrame != frame )
				mc.prevFrame();
			else
				mc.removeEventListener(Event.ENTER_FRAME , reverseEnterFrame);
		}
		
		public function FrameManage()
		{
		}
	}
}