package com.sleepydesign.robotlegs.apps.view
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.robotlegs.apps.AppContext;

	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.core.IModule;
	import org.robotlegs.utilities.modular.core.IModuleContext;

	public class AppModule extends SDSprite implements IModule
	{

		[Inject]
		public function set parentInjector(value:IInjector):void
		{
			_context = new AppContext(this, value);
		}

		protected var _context:IModuleContext;

		// create ------------------------------------------------------------------

		// update ------------------------------------------------------------------

		// destroy ------------------------------------------------------------------

		public function dispose():void
		{
			if (_context)
			{
				_context.dispose();
				_context = null;
			}
		}
	}
}
