package com.sleepydesign.robotlegs.apps
{
	import com.sleepydesign.robotlegs.apps.view.ITransition;

	public class AppConfig
	{
		//default layer
		public static const SYSTEM_LAYER:String = "system_layer";
		public static const BG_LAYER:String = "menu_layer";
		public static const APP_LAYER:String = "app_layer";
		public static const TOP_LAYER:String = "top_layer";
		public static const LIGHTBOX_LAYER:String = "lightbox_layer";
		public static const PRELOAD_LAYER:String = "preload_layer";

		// default module
		public static var DEFAULT_MODULE_NAME:String;

		// all modules 
		public static var modules:Vector.<Class>;

		// all layers 
		public static var layers:Vector.<String> = Vector.<String>([AppConfig.SYSTEM_LAYER, AppConfig.APP_LAYER, AppConfig.LIGHTBOX_LAYER]);

		// transitions
		public static var transition:ITransition;

		// before startup proxy
		public static var beforeStartup:Function;

		// startup proxy
		public static var startup:Function;

		// startup proxy
		public static var onStartup:Function;


	}
}
