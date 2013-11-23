package com.sleepydesign.robotlegs.shells
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.robotlegs.apps.AppConfig;
	import com.sleepydesign.robotlegs.apps.view.AppModule;
	import com.sleepydesign.robotlegs.shells.view.ShellMediator;
	import com.sleepydesign.robotlegs.shells.view.ShellView;
	import com.sleepydesign.system.DebugUtil;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	import org.robotlegs.utilities.modular.mvcs.ModuleContext;

	public class ShellContext extends ModuleContext
	{
		private var _layers:Dictionary;

		public function ShellContext(contextView:DisplayObjectContainer = null)
		{
			super(contextView);
		}

		public function mapSingletons(mapSingletonClasses:Vector.<Class>):void
		{
			for each (var clazz:Class in mapSingletonClasses)
				injector.mapSingleton(clazz);
		}

		override public function startup():void
		{
			DebugUtil.trace(" * " + this + ".startup");

			// call custom config while startup
			if (AppConfig.startup is Function)
				AppConfig.startup(viewMap, injector, signalCommandMap);

			viewMap.mapType(AppModule);

			mediatorMap.mapView(ShellView, ShellMediator);

			if (AppConfig.layers && (AppConfig.layers.length > 0))
				createLayers(AppConfig.layers);

			DebugUtil.trace(" * " + this + ".beforeStartup");

			if (AppConfig.beforeStartup is Function)
				AppConfig.beforeStartup(this);

			addApp();

			super.startup();

			// call custom config while startup
			if (AppConfig.onStartup is Function)
				AppConfig.onStartup(this);
		}

		private function createLayers(layers:Vector.<String>):void
		{
			_layers = new Dictionary;
			for each (var layerName:String in layers)
			{
				_layers[layerName] = contextView.addChild(new SDSprite);
				_layers[layerName].name = layerName;
			}
		}

		public function addApp():void
		{
			if (_layers)
				_layers[AppConfig.APP_LAYER].addChild(new AppModule);
			else
				contextView.addChild(new AppModule);
		}

		public function get layers():Dictionary
		{
			return _layers;
		}
	}
}
