package com.sleepydesign.robotlegs.apps
{
	import com.sleepydesign.robotlegs.apps.model.AppModel;
	import com.sleepydesign.robotlegs.apps.view.AppMediator;
	import com.sleepydesign.robotlegs.apps.view.AppModule;
	import com.sleepydesign.robotlegs.modules.ModuleBase;
	import com.sleepydesign.system.DebugUtil;

	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;

	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;

	public class AppContext extends ModuleContext
	{
		public function AppContext(contextView:DisplayObjectContainer = null, parentInjector:IInjector = null)
		{
			super(contextView, true, parentInjector);
		}

		override public function startup():void
		{
			DebugUtil.trace(" * " + this + ".startup");

			injector.mapSingleton(AppModel);

			if (AppConfig.modules)
				for each (var clazz:Class in AppConfig.modules)
					viewMap.mapType(clazz);

			mediatorMap.mapView(AppModule, AppMediator);

			super.startup();
		}

		override public function dispose():void
		{
			// override me

			mediatorMap.unmapView(getDefinitionByName(ModuleBase(contextView).ID) as Class);
			mediatorMap.removeMediatorByView(contextView);

			super.dispose();
		}
	}
}
