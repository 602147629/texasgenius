package com.sleepydesign.robotlegs.apps.view
{
	import com.sleepydesign.robotlegs.apps.AppConfig;
	import com.sleepydesign.robotlegs.apps.model.AppModel;
	import com.sleepydesign.system.DebugUtil;

	import flash.display.DisplayObject;

	import org.robotlegs.utilities.modular.mvcs.ModuleMediator;

	public class AppMediator extends ModuleMediator
	{
		// internal ------------------------------------------------------------------

		[Inject]
		public var model:AppModel;

		[Inject]
		public var view:AppModule;

		// create ------------------------------------------------------------------

		override public function onRegister():void
		{
			model.viewManager.viewChangeSignal.add(onViewChanged);

			if (AppConfig.DEFAULT_MODULE_NAME)
				model.viewManager.viewID = AppConfig.DEFAULT_MODULE_NAME;
			else
				throw Error("AppConfig.DEFAULT_MODULE_NAME never defined.");
		}

		// system event ------------------------------------------------------------------

		private function onViewChanged(viewID:String):void
		{
			if (model.viewManager.getViewByID(viewID))
				view.addChild(model.viewManager.getViewByID(viewID) as DisplayObject);
		}

		// destroy ------------------------------------------------------------------

		override public function onRemove():void
		{
			DebugUtil.trace(" ! " + this + ".onRemove");
		}
	}
}
