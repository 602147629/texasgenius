package net.area80.component.composer.transition
{
	import flash.display.DisplayObject;
	import net.area80.component.composer.core.IComposerComponent;
	import org.osflash.signals.Signal;
	
	public class Transition implements IComposerComponent
	{
		public var SIGNAL_TRANSITION_IN_COMPLETE:Signal = new Signal();
		public var SIGNAL_TRANSITION_OUT_COMPLETE:Signal = new Signal();
		
		protected var _skin:DisplayObject;

		public function Transition($skin:DisplayObject)
		{
			_skin = $skin;
		}
		
		public function resetToStart ():void {
			
		}
		public function transitionIn ():void {
			
		}
		public function transitionOut ():void {
			
		}
		protected function onTransitionInComplete ():void {
			SIGNAL_TRANSITION_IN_COMPLETE.dispatch();
		}
		protected function onTransitionOutComplete ():void {
			SIGNAL_TRANSITION_OUT_COMPLETE.dispatch();
		}
		
		public function dispose():void
		{
		}
		
		public function get skin():DisplayObject
		{
			return _skin;
		}
		
	}
}