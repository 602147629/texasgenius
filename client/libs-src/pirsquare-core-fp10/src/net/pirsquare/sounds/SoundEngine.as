package net.pirsquare.sounds
{
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	public class SoundEngine
	{

		private static var _getDefinitions:Dictionary = new Dictionary();
		private static var _getSounds:Dictionary = new Dictionary();

		private static var _assetID:String;
		private static var _groupID:String;
		private static var _autoPlay:Boolean = true;
		private static var _transformOn:SoundTransform;
		private static var _transformSelected:SoundTransform;
		private static var _transformUnSelected:SoundTransform;
		private static var _transformOff:SoundTransform;

		private static var _soundPlay:Sound;
		private static var _soundChannelPlay:SoundChannel;
		private static var _fadeChannelOn:SoundChannel;
		private static var _fadeChannelOff:SoundChannel;


		private static var _loader:Loader;
		private static var _sinal:Signal;

		private static var _info:LoaderInfo;
		private static var _isFading:Boolean;

		private static var _isMute:Boolean;


		public static function getSound(soundClass:Class):Sound
		{
			try
			{
				return new soundClass as Sound;
			}
			catch (e:*)
			{
				return null;
			}
			return null;
		}

		/**
		 *
		 * add transform to sound
		 *
		 */
		public static function crossFade(soundClass:Class):void
		{
			if (_isMute)
				return;

			if (_isFading)
				return;

			// set old sound 
			if (_soundPlay)
			{
				var snd:Sound = _soundPlay;
				var sndChannel:SoundChannel = _soundChannelPlay;
				var old_sndPosition:int = sndChannel.position;

				_transformOff = sndChannel.soundTransform;
				_fadeChannelOff = sndChannel;
			}

			// set new sound 
			_soundPlay = getSound(soundClass);

			// check sound
			if (_soundPlay == snd)
			{
				reset();
				return;
			}
			_soundChannelPlay = _soundPlay.play(old_sndPosition);

			// set defualt volume = 0
			var transform:SoundTransform = new SoundTransform();
			transform.volume = 0;
			_soundChannelPlay.soundTransform = transform;

			_transformOn = _soundChannelPlay.soundTransform;
			_fadeChannelOn = _soundChannelPlay;

			// action fading
			fade();
		}

		public static function fade():void
		{
			_isFading = true;

			TweenLite.to(_transformOn, 1, {volume: 1, onUpdate: fading, onComplete: reset});

			if (_transformOff)
				TweenLite.to(_transformOff, 1, {volume: 0, onUpdate: fading, onComplete: reset});
		}

		private static function fading():void
		{
			if (_fadeChannelOff)
			{
				_fadeChannelOff.soundTransform = _transformOff;
				_soundChannelPlay = _fadeChannelOff;
			}

			if (_fadeChannelOn)
			{
				_fadeChannelOn.soundTransform = _transformOn;
				_soundChannelPlay = _fadeChannelOn;
			}

		}

		private static function reset():void
		{
			_isFading = false;
			_transformOff = null;
			_fadeChannelOff = null;
			_transformOn = null;
			_fadeChannelOn = null;
		}


		/**
		 *
		 * tween sound tranform to mute
		 *
		 */
		public static function mute():void
		{
			if (!_soundChannelPlay)
				return;

			TweenLite.killTweensOf(_transformOff);

			_transformOff = _soundChannelPlay.soundTransform;
			_fadeChannelOff = _soundChannelPlay;
			TweenLite.to(_transformOff, 1, {volume: 0, onUpdate: fading, onComplete: reset});
		}

		public static function unmute():void
		{
			if (!_soundChannelPlay)
				return;

			TweenLite.killTweensOf(_fadeChannelOn);

			_transformOn = _soundChannelPlay.soundTransform;
			_fadeChannelOn = _soundChannelPlay;
			TweenLite.to(_transformOn, 1, {volume: 1, onUpdate: fading, onComplete: reset});
		}

		/**
		 *
		 * @param assetID
		 *
		 */
		public static function play(soundClass:Class):void
		{
			if (_isMute)
				return;

			if (!_soundPlay)
			{
				_soundPlay = getSound(soundClass);
				playSound();

			}
			else
			{
				if (_soundChannelPlay)
				{
					_soundChannelPlay.removeEventListener(Event.SOUND_COMPLETE, onSoundChannelSoundComplete);
					stop();
				}

				_soundPlay = getSound(soundClass);
				playSound();
			}

			_isFading = false;
		}

		private static function playSound():void
		{
			_soundChannelPlay = _soundPlay.play();
			_soundChannelPlay.addEventListener(Event.SOUND_COMPLETE, onSoundChannelSoundComplete);
		}

		protected static function onSoundChannelSoundComplete(event:Event):void
		{
			_soundChannelPlay.removeEventListener(Event.SOUND_COMPLETE, onSoundChannelSoundComplete);
			playSound()
		}

		/**
		 *
		 *
		 */
		public static function stop():void
		{
			if (_soundChannelPlay)
				_soundChannelPlay.stop();
		}

		public static function get isMute():Boolean
		{
			return _isMute;
		}

		public static function set isMute(value:Boolean):void
		{
			_isMute = value;

			if (_soundChannelPlay)
				_soundChannelPlay.stop();

			SoundMixer.stopAll();
		}

		public static function set volume(value:Number):void
		{
			var st:SoundTransform = new SoundTransform();
			st.volume = value;
			_soundChannelPlay.soundTransform = st;
		}

	}
}
