package com.sleepydesign.net
{

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	import org.osflash.signals.Signal;

	public class AssetUtil
	{
		private static const _getDefinitions:Dictionary = new Dictionary(true);
		public static var useCurrentApplicationDomain:Boolean = false;

		// StandAlone or Browser
		public static function isBrowser():Boolean
		{
			return Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn";
		}

		// from external swf
		public static function loadSWF(path:String, groupID:String, version:String = null, eventHandler:Function = null):URLLoader
		{
			if (_getDefinitions[groupID])
			{
				eventHandler();
				return null;
			}
			else
			{
				var uri:String = path + groupID + ".swf" + (isBrowser() ? (version ? "?v=" + version : "") : "");
				var onComplete:Function;


				if (useCurrentApplicationDomain)
				{
					// use current domain as loaded swf application domain - for ipad
					_applicationDomain = ApplicationDomain.currentDomain;
				}
				else
				{
					// always new context for each swf
					_applicationDomain = new ApplicationDomain();
				}

				var loaderContext:LoaderContext = new LoaderContext(false, _applicationDomain);
				loaderContext.allowCodeImport = true;

				// only AIR
				if (Capabilities.playerType == "Desktop")
					loaderContext.allowLoadBytesCodeExecution = true;

				const loader:URLLoader = LoaderUtil.loadBinary(uri, onComplete = function(event:Event):void
				{
					eventHandler(event);

					if (event.type != Event.COMPLETE)
						return;

					var _ba:ByteArray = event.target.data as ByteArray;
					registerDefinition(groupID, _ba).addOnce(eventHandler);

					_ba.clear();
					event.target.data = _ba = null;

					onComplete = null;
					loaderContext = null;

				}, loaderContext);

				return loader;
			}
		}

		public static function getClass(groupID:String, assetID:String):Class
		{
			if (!(_getDefinitions[groupID] is Function))
				throw new Error("Not found : " + groupID + ", Must loadSWF or loadEmbedSWF before call getClass");

			try
			{
				return _getDefinitions[groupID](assetID) as Class;
			}
			catch (e:*)
			{
				//trace(e);
				return null;
			}

			return null;
		}

		public static function getSimpleButton(groupID:String, assetID:String):SimpleButton
		{
			try
			{
				return new (AssetUtil.getClass(groupID, assetID)) as SimpleButton;
			}
			catch (e:*)
			{
				return null;
			}
			return null;
		}

		public static function getBitmapData(groupID:String, assetID:String):BitmapData
		{
			try
			{
				return new (AssetUtil.getClass(groupID, assetID)) as BitmapData;
			}
			catch (e:*)
			{
				return null;
			}
			return null;
		}

		public static function getDisplayObject(groupID:String, assetID:String):DisplayObject
		{
			try
			{
				return new (AssetUtil.getClass(groupID, assetID)) as DisplayObject;
			}
			catch (e:*)
			{
				return null;
			}
			return null;
		}

		public static function getSprite(groupID:String, assetID:String):Sprite
		{
			return getDisplayObject(groupID, assetID) as Sprite;
		}

		public static function getMovieClip(groupID:String, assetID:String):MovieClip
		{
			return getDisplayObject(groupID, assetID) as MovieClip;
		}

		public static function getSound(groupID:String, assetID:String):Sound
		{
			try
			{
				return new (AssetUtil.getClass(groupID, assetID)) as Sound;
			}
			catch (e:*)
			{
				return null;
			}
			return null;
		}

		private static var _applicationDomain:ApplicationDomain;

		public static function registerDefinition(groupID:String, byteArray:ByteArray):Signal
		{
			var loader:Loader = new Loader();
			var handler:Function;
			var signal:Signal = new Signal();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				_getDefinitions[groupID] = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				signal.dispatch();

				// gc
				signal = null;
				handler = null;

				loader.unload();
				loader.unloadAndStop();
				loader = null;

				loaderContext = null;
				_applicationDomain = null;

				System.gc();
			});

			if (!byteArray || byteArray.length <= 0)
				trace(" ! ERROR : Server return empty data : " + groupID);

			//_applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain); //loader.contentLoaderInfo.applicationDomain);
			loaderContext.allowCodeImport = true;

			// only AIR
			if (Capabilities.playerType == "Desktop")
				loaderContext.allowLoadBytesCodeExecution = true;

			loader.loadBytes(byteArray, loaderContext);

			return signal;
		}

		public static function unregisterDefinition(groupID:String):void
		{
			_getDefinitions[groupID] = null;

			System.gc();
		}

		public static function loadClass(assets:Class, groupID:String, assetID:String = null, typeClass:Class = null):Signal
		{
			var loader:Loader = new Loader();
			var handler:Function;
			var signal:Signal = typeClass ? new Signal(typeClass) : new Signal;

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				_getDefinitions[groupID] = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;

				if (assetID && signal.valueClasses.length > 0)
				{
					if (describeType(signal.valueClasses[0]) == describeType(typeClass))
					{
						var clazz:Class = _getDefinitions[groupID](assetID) as Class;
						signal.dispatch(new clazz as typeClass);

						clazz = null;
					}
				}
				else
				{
					signal.dispatch();
				}

				signal = null;

				loader.unload();
				loader.unloadAndStop();
				loader = null;
			});

			loader.loadBytes(new assets as ByteArray, new LoaderContext(false, loader.contentLoaderInfo.applicationDomain));

			return signal;
		}

		public static function loadBytes(byteArray:ByteArray, id:String = null, typeClass:Class = null):Signal
		{
			const loader:Loader = new Loader();
			var handler:Function;
			var signal:Signal;

			if (id)
			{
				if (!typeClass)
					typeClass = Class;

				signal = new Signal(typeClass);
			}
			else
				signal = new Signal();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				const getDefinitions:Function = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				var clazz:Class;

				if (signal.valueClasses.length > 0)
				{
					if (describeType(signal.valueClasses[0]) == describeType(typeClass))
					{
						clazz = getDefinitions(id) as Class;
						signal.dispatch(clazz);
					}
				}
				else
				{
					signal.dispatch();
				}
			});

			loader.loadBytes(byteArray, new LoaderContext(false, loader.contentLoaderInfo.applicationDomain));

			return signal;
		}

		public static function hasDefinition(groupID:String, assetID:String):Boolean
		{
			if (!_getDefinitions[groupID])
				return false;

			if (!(_getDefinitions[groupID] is Function))
				return false;

			try
			{
				if (_getDefinitions[groupID](assetID) as Class)
					return true;
				else
					return false;
			}
			catch (e:*)
			{
				return false;
			}

			return false;
		}
	}
}
