package net.pirsquare.sounds.soundplayer
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import net.pirsquare.sounds.core.IAudioItem;
	import net.pirsquare.sounds.core.Mixer;
	import net.pirsquare.sounds.core.SoundCore;
	import net.pirsquare.sounds.event.AudioEvents;
	import net.pirsquare.sounds.musicplayer.Track;
	
	public class SoundPlayer extends EventDispatcher implements IAudioItem 
	{
		//------------Group----------------
		protected var _soundDatas:Array = [];/*IAudioItem*/
		protected var _numChildren:int;
		
		//---------- Info ----------------
		protected var _uid:int;
		protected var _name:String;
		
		//----------- Params --------------
		protected var _fadeAtEnd:Boolean;				
		
		//----------- Navigation --------------	
		protected var _loop:Boolean;		
		protected var _paused:Boolean = true;			
		
		//----------- Sound transforms --------------			
		protected var _facadeVolume:Number = 1;
		protected var _refFacadeVolume:Number = 1;
		protected var _volumeMultiplier:Number = 1;			
		protected var _muted:Boolean = false;	
		protected var _facadePan:Number = 0;				
		protected var _refFacadePan:Number = 0;				
		protected var _panMultiplier:Number = 0;						
		
		
		public function SoundPlayer(items:* = null, name:String = null) 
		{
			_uid = SoundCore.getUid();
			_name = (name) ? _name : String(_uid);
			
			SoundCore.manager.add(this);	
			
			if (!items) return;
			
			addFrom(items);
		}
		
		public function addFrom(_items:*):void
		{
			if (_items is IAudioItem)	
				addChild(_items as IAudioItem);
			else
				for each (var i:* in _items) addChild(i as IAudioItem)
			
		}
		
		/**
		 * Adds a child audio item instance to this group.
		 * @param	item  The audio item to add as a child of this group.
		 * @return	The audio item that you pass in the child parameter. 
		 */
		public function addChild(item:IAudioItem):IAudioItem 
		{
			add(item);
			return item;			
		}
		
		/**
		 * Removes the specified child audio item from the child list of this group. 
		 * @param	item  The audio item to remove.
		 * @return  The audio item that you pass in the child parameter. 
		 */
		public function removeChild(item:IAudioItem):IAudioItem
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				if (item == _soundDatas[i])
				{
					var rmvd:IAudioItem = _soundDatas[i];
					remove(i);
					return rmvd;
				}
			}
			return null;			
		}
		
		/**
		 * Determines whether the specified audio item is a child of this group/list.
		 * @param	item The child item to test.  
		 * @return
		 */
		public function contains(item:IAudioItem):Boolean
		{
			for each (var i:IAudioItem in _soundDatas) { if (i == item)	return true; }
			return false;	
		}
		
		/**
		 * Returns the child audio item that exists with the specified auto-generated unique identifier.
		 * @param	__id The uid of the child to return.  
		 * @return The child audio item with the specified uid.
		 */
		public function getChildById(_uid:int):IAudioItem
		{
			return SoundCore.manager.getItemById(_uid);
		}
		
		/**
		 * Returns the child audio item that exists with the specified name. If more that one child 
		 * has the specified name, the method returns the first object in the child list. 
		 * @param	__name  The name of the child to return.  
		 * @return  The child audio item with the specified name.
		 */
		public function getChildByName(_name:String):IAudioItem
		{
			for each (var i:IAudioItem in _soundDatas)  { if (i.name == _name)	return i;	}
			return null;
		}
		
		/**
		 * Returns the number of children of this group/list. 
		 */
		public function get numChildren():int
		{
			return _numChildren;
		}
		
		/**
		 * Returns an array that contains all of the group/list's children.
		 */
		public function get children():Array
		{
			return _soundDatas;
		}
		
		/**
		 * Loads sounds urls provided, creates and adds corresponding AudioTracks to the group/list's
		 * child list.
		 * @param	urls An array of urls to load.
		 */
		public function addTracksFromUrls(urls:/*String*/Array):void
		{
			for each (var track:String in urls)
			{
				add(new Track(track));
			}
			
		}
		
		//----------------------- Info ---------------------------------------------------------------------------------------------------		 		
		
		/**
		 * @inheritDoc
		 */
		public function get uid():uint
		{
			return _uid;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void 
		{
			_name = value;
		}	
		
		/**
		 * @inheritDoc
		 */		
		public function get peakLeft():Number
		{
			var leftPeakSum:Number = 0;
			for each (var i:IAudioItem in _soundDatas) { if (i.peakLeft > 0) leftPeakSum += i.peakLeft; }
			return leftPeakSum / numChildren;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get peakRight():Number
		{
			var rightPeakSum:Number = 0;
			for each (var i:IAudioItem in _soundDatas) { if (i.peakRight > 0) rightPeakSum += i.peakRight; }
			return rightPeakSum / numChildren;			
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get peak():Number
		{
			var peakSum:Number = 0;
			for each (var i:IAudioItem in _soundDatas) { if (i.peak > 0) peakSum += i.peak; }
			return peakSum / numChildren;			
		}
		
		
		/**
		 * @inheritDoc
		 */	
		public function get volumeUnits():Number
		{
			return 0;
		}
		
		
		/**
		 * @inheritDoc
		 */			
		public function cookieWrite(cookieId:String):Boolean
		{
			var p:Object = { volume:volume, pan:pan };
			return SoundCore.cookieWrite(cookieId, p);
		}
		
		/**
		 * @inheritDoc
		 */		
		public function cookieRetrieve(cookieId:String):void
		{
			var soData:Object = SoundCore.cookieRetrieve(cookieId);
			volume = (soData.volume) ? soData.volume : _facadeVolume;
			pan = (soData.pan) ? soData.pan : _facadePan;
		}
		
		
		//----------------------- Params ---------------------------------------------------------------------------------------------------		 				
		/**
		 * Fades out volume at the end of each group's track, using time set by 
		 * <code>AudioParams.DURATION_TRANSITIONS</code>
		 */
		public function get fadeAtEnd():Boolean
		{
			return _fadeAtEnd;
		}		
		
		public function set fadeAtEnd(value:Boolean):void
		{
			_fadeAtEnd = value;
			for each (var i:IAudioItem in _soundDatas) { trace(i);  i.fadeAtEnd = value; };
		}
		
		//----------------------- Navigation ---------------------------------------------------------------------------------------------------
		/**
		 * Load and plays group's children.
		 * @param 	_fadeIn Fades volume in, using time set by <code>AudioAPI.DURATION_PLAYBACK_FADE</code>.
		 * @param	_startTime  The initial position at which playback should start for each child. If _startTime > 1, value is in milliseconds. If _startTime <= 1, value is from 0 (begining of the track) to 1 (end of the track). 
		 * @param	_useStartTimeFromCookie N/A
		 */
		public function start(_fadeIn:Boolean = false, _startTime:Number = 0, _useStartTimeFromCookie:Boolean = false):void
		{
			_paused = false;
			
			setVolume(_refFacadeVolume);
			setPan(_refFacadePan);
			
			for each (var i:IAudioItem in _soundDatas) { i.start(false, _startTime); }
			
			if (_fadeIn) volumeTo(Mixer.DURATION_PLAYBACK_FADE, _facadeVolume, 0, false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function stop(_fadeOut:Boolean = false):void
		{
			if (_fadeOut) volumeTo(Mixer.DURATION_PLAYBACK_FADE, 0, _facadeVolume, false, stop);
			else clear();
		}
		
		/**
		 * @inheritDoc
		 */
		public function pause(_fadeOut:Boolean = false):void
		{
			if (_paused) return;
			_paused = true;
			
			if (_fadeOut) volumeTo(Mixer.DURATION_PLAYBACK_FADE, 0, _facadeVolume, false, pause);
				
			else 
			{
				for each (var i:IAudioItem in _soundDatas)  { i.pause(false); }							
				//clear();			
			}
		}
		
		/**
		 * @inheritDoc
		 * fadeIn won't work
		 */
		public function resume(_fadeIn:Boolean = false):void
		{
			if (!_paused) return;
			_paused = false;
			
			for each (var i:IAudioItem in _soundDatas) { i.resume(); }				
			
			if (_fadeIn) volumeTo(Mixer.DURATION_PLAYBACK_FADE, _refFacadeVolume, 0, false);
			else setVolume(_refFacadeVolume);					
			
		}
		
		
		public function togglePause(_fade:Boolean = false):void
		{
			if (_paused) resume(_fade) else pause(_fade);
		}
		
		/**
		 * Determines whether the group's children should repeat themselves or not.
		 */			
		public function set loop(value:Boolean):void  
		{
			for each (var i:IAudioItem in _soundDatas) { i.loop = value; }
		}				
		
		
		
		//----------------------- Sound transforms ---------------------------------------------------------------------------------------------------		
		
		/**
		 * @inheritDoc
		 */
		public function get volume():Number
		{
			return _facadeVolume;
		}		
		
		public function set volume(value:Number):void
		{
			setVolume(value);
			_refFacadeVolume = value;
		}		
		
		public function setVolume(value:Number):void
		{
			_facadeVolume = value;
			applyVolume()
		}
		
		/**
		 * @private
		 */
		public function get volumeMultiplier():Number
		{
			return _volumeMultiplier;
		}
		public function set volumeMultiplier(value:Number):void
		{
			_volumeMultiplier = value;
			applyVolume();
		}		
		
		/**
		 * @inheritDoc
		 */
		public function mute(_fadeOut:Boolean = false):void
		{		
			if (_muted) return;
			_muted = true;
			
			if (_fadeOut) volumeTo(Mixer.DURATION_MUTE_FADE, 0, _facadeVolume, false);
			else setVolume(0);			
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmute(_fadeIn:Boolean = false):void
		{		
			if (!_muted) return;
			_muted = false;
			
			if (_fadeIn) volumeTo(Mixer.DURATION_MUTE_FADE, _refFacadeVolume, 0, false);
			else setVolume(_refFacadeVolume);		
		}		
		
		/**
		 * @inheritDoc
		 */		
		public function toggleMute(_fade:Boolean = false):void
		{
			if (_muted) unmute(_fade) else mute(_fade);
		}		
		
		
		/**
		 * @inheritDoc
		 */		
		public function get pan():Number
		{
			return _facadePan;
			
		}
		public function set pan(value:Number):void
		{
			setPan(value);
			_refFacadePan = value;
		}	
		
		public function setPan(value:Number):void
		{
			_facadePan = value;
			applyPan()
		}		
		
		/**
		 * @private
		 */
		public function get panMultiplier():Number
		{
			return _panMultiplier;
		}
		public function set panMultiplier(value:Number):void
		{
			_panMultiplier = value;
			applyPan();			
		}			
		
		/**
		 * @inheritDoc
		 */				
		public function left(_fade:Boolean = false):void
		{
			if (_fade) panTo(Mixer.DURATION_PAN_FADE, SoundCore.LEFT);
			else pan = SoundCore.LEFT;
		}
		
		/**
		 * @inheritDoc
		 */				
		public function center(_fade:Boolean = false):void
		{
			if (_fade) panTo(Mixer.DURATION_PAN_FADE, SoundCore.CENTER);
			else pan = SoundCore.CENTER;
		}
		
		/**
		 * @inheritDoc
		 */				
		public function right(_fade:Boolean = false):void
		{
			if (_fade) panTo(Mixer.DURATION_PAN_FADE, SoundCore.RIGHT);
			else pan = SoundCore.RIGHT;
		}		
		
		//-------------------------------------Sound transitions--------------------------------
		
		/**
		 * @inheritDoc
		 */		
		public function volumeTo(time:Number = NaN, endVolume:Number = NaN, startVolume:Number = NaN, keepChanges:Boolean = true, callback:Function = null):void
		{
			var s:Number = isNaN(startVolume) ? _facadeVolume : startVolume;
			var e:Number = isNaN(endVolume) ? _facadeVolume : endVolume;
			var t:Number = isNaN(time) ? Mixer.DURATION_DEFAULT : time;
			SoundCore.manager.volumeTo(_uid, time, s, e, keepChanges, callback);
		}		
		
		/**
		 * @inheritDoc
		 */				
		public function panTo(time:Number = NaN, endPan:Number = NaN, startPan:Number = NaN, keepChanges:Boolean = true):void		
		{
			var s:Number = isNaN(startPan) ? _facadePan : startPan;
			var e:Number = isNaN(endPan) ? _facadePan : endPan;
			var t:Number = isNaN(time) ? Mixer.DURATION_DEFAULT : time;
			SoundCore.manager.panTo(_uid, time, s, e, keepChanges);
		}				
		
		/**
		 * @inheritDoc
		 */				
		public function crossfade(targetAudio:IAudioItem, time:Number = NaN):void
		{
			var t:Number = isNaN(time) ? Mixer.DURATION_TRANSITIONS : time;
			volumeTo(time, 0, _facadeVolume, false, clear);
			targetAudio.start(false);
			targetAudio.volumeTo(time, NaN, 0, false);
		}
		//-------------------------------------HIDDEN METHODS--------------------------------		
		
		/**
		 * @private
		 */		
		public function clear():void
		{
			//trace("grp clear");
			for each (var i:IAudioItem in _soundDatas) { i.clear();	}
		}			
		
		//-------------------------------------PRIVATE METHODS--------------------------------		
		
		
		protected function add(item:IAudioItem, index:int = -1):void
		{
		
			(index == -1) ? _soundDatas.push(item) : _soundDatas.splice(index, 0, item);
			setAudio(item);
			_numChildren++;
			
		}
		
		
		protected function setAudio(item:IAudioItem, index:int = -1):void
		{
			item.volumeMultiplier = _facadeVolume * _volumeMultiplier;
			item.panMultiplier = _facadePan;
			item.fadeAtEnd = _fadeAtEnd;
		}
		
		
		protected function remove(index:int):void
		{
			_soundDatas.splice(index, 1);
			_numChildren--;
		}
		
		private function loadPlsFromFile(url:String, callback:Function):void
		{
			var ldr:URLLoader = new URLLoader();
			ldr.dataFormat = URLLoaderDataFormat.TEXT;
			ldr.addEventListener(Event.COMPLETE, callback);
			ldr.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler)
			ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler)
			ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, HTTPStatusHandler) 			
			ldr.load(new URLRequest(url));
		}		
		
		private function applyVolume():void
		{
			if (_facadeVolume < 0) _facadeVolume = 0;
			if (_facadeVolume > 1) _facadeVolume = 1;
			
			var _realVolume:Number = _facadeVolume * _volumeMultiplier;
			
			for each (var i:IAudioItem in _soundDatas) { i.volumeMultiplier = _realVolume; }				
			
			dispatchEvent(new Event(AudioEvents.VOLUME_CHANGE));	
		}
		
		private function applyPan():void
		{
			if (_facadePan < SoundCore.LEFT) _facadePan = SoundCore.LEFT;
			if (_facadePan > SoundCore.RIGHT) _facadePan = SoundCore.RIGHT;
			
			
			for each (var i:IAudioItem in _soundDatas) { i.panMultiplier = _facadePan; }
			
			dispatchEvent(new Event(AudioEvents.PAN_CHANGE));
		}
		
		
		private function IOErrorHandler(evt:IOErrorEvent):void				{ trace("IOError: " + evt.text); }
		private function HTTPStatusHandler(evt:HTTPStatusEvent):void		{ /*if (evt.status!=200) throw new Error("HTTPStatus: " + evt.status);*/ }
		private function securityErrorHandler(evt:SecurityErrorEvent):void	{ trace("SecurityError: " + evt.text); }
		
	}
	
}


