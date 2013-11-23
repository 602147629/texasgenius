package com.sleepydesign.display
{
	import com.sleepydesign.core.IDestroyable;

	import flash.events.Event;

	public class SDStageSprite extends SDSprite implements IDestroyable
	{
		public function SDStageSprite()
		{
			super();

			var _onStage:Function;
			addEventListener(Event.ADDED_TO_STAGE, _onStage = function(event:Event):void
			{
				removeEventListener(Event.ADDED_TO_STAGE, _onStage);
				onStage();
			}, false, 0, true);
		}

		protected function onStage():void
		{

		}

		override public function destroy():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			super.destroy();
		}
	}
}
