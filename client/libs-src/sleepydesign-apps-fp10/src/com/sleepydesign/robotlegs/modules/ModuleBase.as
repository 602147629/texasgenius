package com.sleepydesign.robotlegs.modules
{
	import com.sleepydesign.robotlegs.apps.view.IView;
	import com.sleepydesign.display.SDSprite;

	import flash.utils.getQualifiedClassName;

	import org.osflash.signals.Signal;
	import org.robotlegs.utilities.modular.core.IModuleContext;

	public class ModuleBase extends SDSprite implements IView
	{
		protected var _context:IModuleContext;

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
		
		public function create():void
		{
			
		}

		// update ------------------------------------------------------------------

		public function activate(onActivated:Function, prevView:IView = null):void
		{
			// override me!
			onActivated();
		}

		public function deactivate(onDeactivated:Function, nextView:IView = null):void
		{
			// override me!
			onDeactivated();
		}

		// destroy ------------------------------------------------------------------

		public function dispose():void
		{
			if (_context)
			{
				_context.dispose();
				_context = null;
			}
			
			_completeSignal.removeAll();
		}
	}
}
