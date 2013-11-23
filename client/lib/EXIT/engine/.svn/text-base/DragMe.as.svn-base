package EXIT.engine
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;

	public class DragMe
	{
		private var stage							:Stage;
		private var mc								:DisplayObject;
		public function DragMe( $mc : DisplayObject )
		{
			mc = $mc;
			if( $mc.stage ) initial;
			else $mc.addEventListener( Event.ADDED_TO_STAGE , initial );
		}
		
		protected function initial(event:Event = null):void
		{
			stage = mc.stage;
			mc.addEventListener(Event.REMOVED_FROM_STAGE , dispose );
			
			mc
		}
		
		protected function dispose(event:Event):void
		{
			
		}
	}
}