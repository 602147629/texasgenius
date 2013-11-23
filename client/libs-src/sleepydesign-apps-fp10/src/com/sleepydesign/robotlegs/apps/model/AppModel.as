package com.sleepydesign.robotlegs.apps.model
{
	import org.robotlegs.mvcs.Actor;

	public class AppModel extends Actor
	{
		private var _viewManager:ViewManager = new ViewManager();

		public function get viewManager():ViewManager
		{
			return _viewManager;
		}
	}
}
