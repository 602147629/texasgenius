package net.area80.component.composer.inputform
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import net.area80.component.composer.core.IComposerComponent;
	
	import org.osflash.signals.Signal;

	public class CheckBox implements IComposerComponent
	{
		public var SIGNAL_CHANGE:Signal = new Signal(Boolean);
		protected var _skin:MovieClip;
		
		public function CheckBox($skin:MovieClip)
		{
			this._skin = $skin;
			_skin.buttonMode = true;
			_skin.gotoAndStop(1);
			_skin.addEventListener(MouseEvent.CLICK, toggleHandler);
		}
		
		private function toggleHandler (e:MouseEvent):void { 
			if(_skin.currentFrame==1) {
				_skin.gotoAndStop(2);
			} else {
				_skin.gotoAndStop(1);
			}
			SIGNAL_CHANGE.dispatch(checked);
		}
		
		public function get value ():* {
			return checked;
		}
		public function get checked ():Boolean {
			return (_skin.currentFrame==2);
		}
		public function set checked (b:Boolean):void {
			_skin.gotoAndStop(((b) ? 2 : 1));
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