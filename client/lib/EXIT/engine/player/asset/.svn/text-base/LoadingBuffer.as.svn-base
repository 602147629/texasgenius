package EXIT.engine.player.asset
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	[Embed(source='embed/player/playerVdo/loading_vdo.swf',symbol='loading')]
	public class LoadingBuffer extends MovieClip
	{
		private var direction			:Number = 1;
		public function LoadingBuffer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , initialize  );
			addEventListener(Event.REMOVED_FROM_STAGE , dispose  );
		}
		
		protected function initialize(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME,checkReverse );
		}
		
		protected function dispose(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,checkReverse );
		}
		
		public function show():void
		{
			visible = true;
			super.play();
			addEventListener(Event.ENTER_FRAME,checkReverse );
			trace('show loading...');
		}
		public function hide():void
		{
			visible = false;
			super.stop();
			removeEventListener(Event.ENTER_FRAME,checkReverse );
			trace('hide loading...');
		}
		
		protected function checkReverse(event:Event):void
		{
			if( direction == -1 ){
				prevFrame();
			}
			
			if( currentFrame == totalFrames ){
				direction=-1;
				stop();
			}else if( currentFrame == 1 ){
				direction=1;
				play();
			}
//			trace('CHECK REVERSE...');
		}
	}
}