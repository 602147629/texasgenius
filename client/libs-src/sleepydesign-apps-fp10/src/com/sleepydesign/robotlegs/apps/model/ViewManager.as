package com.sleepydesign.robotlegs.apps.model
{
	import avmplus.getQualifiedClassName;

	import com.sleepydesign.robotlegs.apps.AppConfig;
	import com.sleepydesign.robotlegs.apps.view.IView;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import org.osflash.signals.Signal;

	// TODO : recursive subview
	public class ViewManager
	{
		// Signals ----------------------------------------------------------------------------------

		private var _viewChangeSignal:Signal = new Signal(String);

		public function get viewChangeSignal():Signal
		{
			return _viewChangeSignal;
		}

		private var _viewChangedSignal:Signal = new Signal(String);

		public function get viewChangedSignal():Signal
		{
			return _viewChangedSignal;
		}

		// Views ----------------------------------------------------------------------------------

		private var _currentView:IView;
		private var _prevView:IView;

		private var _views:Dictionary = new Dictionary;

		private var _viewID:String;

		public function get viewID():String
		{
			return _viewID;
		}

		/**
		 *
		 * Will change view by qualified class name
		 *
		 * @param value: qualified class name eg. com.sleepydesign.helloworld.home.view::HomeModule
		 *
		 */
		public function set viewID(value:String):void
		{
			// ignore
			if (_viewID == value)
				return;

			_viewID = value;

			_prevView = _currentView;

			createViewByID(_viewID);

			_viewChangeSignal.dispatch(_viewID);

			if (AppConfig.transition)
			{
				// transition
				AppConfig.transition.start(_prevView as IView, _currentView as IView, function():void
				{
					// TODO : dispatch transition complete
					_viewChangedSignal.dispatch(_viewID);
				});
			}
			else
			{
				// no transition, just deactivate/activate
				_prevView.deactivate(null, _currentView);
				_currentView.activate(null, _prevView);

				// changed
				_viewChangedSignal.dispatch(_viewID);
			}
		}

		/**
		 *
		 * Will change view by class name
		 *
		 * @param className: simple class name  eg. HomeModule
		 * @example
				<code>
					appModel.viewManager.changeViewByClassName("HomeModule");
				</code>
		 */
		public function changeViewByClassName(className:String):void
		{
			// TODO : optimize this to class util?
			for each (var clazz:Class in AppConfig.modules)
			{
				const clazzName:String = String(String(clazz).split("::").pop());
				if (clazzName == "[class " + className + "]")
				{
					viewID = getQualifiedClassName(clazz);
					return;
				}
			}
		}

		public function createViewByID(viewID:String):void
		{
			if (!_views[viewID])
			{
				var clazz:Class = getDefinitionByName(viewID) as Class;
				_views[viewID] = new clazz();
			}

			_currentView = _views[viewID];
		}

		public function getViewByID(viewID:String):IView
		{
			return _views[viewID];
		}

		public function removeViewByID(viewID:String):void
		{
			_views[viewID] = null;
		}

		public function get prevView():IView
		{
			return _prevView;
		}


		// Construct ----------------------------------------------------------------------------------

	/*
	private static var _this:ViewManager;

	public static function getInstance():ViewManager
	{
		return _this;
	}

	public function ViewManager()
	{
		if (_this)
			throw new Error("Only one ViewManager allow in system!");

		_this = this;
	}
	*/
	}
}
