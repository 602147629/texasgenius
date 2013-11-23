package com.sleepydesign.robotlegs.view
{
	import avmplus.getQualifiedClassName;

	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.robotlegs.apps.view.IView;

	import org.osflash.signals.Signal;

	public class ViewBase extends SDSprite implements IView
	{
		protected const _ID:String = getQualifiedClassName(this);

		public function get ID():String
		{
			return _ID;
		}

		/**
		 * will sent ID when view create complete
		 */
		private const _completeSignal:Signal = new Signal(String);

		public function get completeSignal():Signal
		{
			return _completeSignal;
		}

		// create ------------------------------------------------------------------

		// update ------------------------------------------------------------------

		public function activate(onActivated:Function, prevView:IView = null):void
		{
			// override me!
			onActivated();

			mouseEnabled = true;
			mouseChildren = true;
		}

		public function deactivate(onDeactivated:Function, nextView:IView = null):void
		{
			// override me!
			onDeactivated();

			mouseEnabled = false;
			mouseChildren = false;
		}

		// destroy ------------------------------------------------------------------

		public function dispose():void
		{
			// override me!
			destroy();
		}

	}
}
