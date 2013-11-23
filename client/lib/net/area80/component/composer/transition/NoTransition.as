package net.area80.component.composer.transition
{
	import flash.display.DisplayObject;
	
	public class NoTransition extends Transition
	{
		public function NoTransition($content:DisplayObject)
		{
			super($content);
		}
		
		override public function transitionIn():void
		{
			SIGNAL_TRANSITION_IN_COMPLETE.dispatch();
		}
		
		override public function transitionOut():void
		{
			SIGNAL_TRANSITION_OUT_COMPLETE.dispatch();
		}
		
	}
}