package com.sleepydesign.robotlegs.shells.view
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.robotlegs.shells.ShellContext;
	import com.sleepydesign.system.DebugUtil;

	import flash.utils.Dictionary;

	/**
	 * Will contain layers
	 *
	 * @author katopz
	 *
	 */
	public class ShellView extends SDSprite
	{
		private var _layers:Dictionary;
		private var _context:ShellContext;

		public function ShellView(... args)
		{
			super();
			init();

			if (args && args.length > 0)
				createLayers(args);
		}

		private function init():void
		{
			_context = new ShellContext(this);
			_layers = new Dictionary();


		}

		private function createLayers(... args):void
		{
			for each (var layerName:String in args)
			{
				_layers[layerName] = addChild(new SDSprite);
				_layers[layerName].name = layerName;
			}
		}

	}
}
