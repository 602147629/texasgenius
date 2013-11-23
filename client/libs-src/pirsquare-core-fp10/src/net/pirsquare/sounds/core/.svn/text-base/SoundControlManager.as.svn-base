package net.pirsquare.sounds.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import net.pirsquare.sounds.musicplayer.Track;
	import net.pirsquare.sounds.component.Fade;

	public class SoundControlManager
	{

		//-----------------------Singleton----------------------------------------------------		
		private static var instance:SoundControlManager = new SoundControlManager();

		public function SoundControlManager()
		{
			if (instance)
				throw new Error("Singleton can only be accessed through Singleton.getInstance()");
		}

		public static function getInstance(lock:Class):SoundControlManager
		{
			if (lock != SoundCore)
			{
				throw new Error("core.Manager shouldn't be instanciated externally");
				return null;
			}
			return instance;
		}


		//-----------------------Class body----------------------------------------------------		

		private var items:Array = [];
		private var itemsVolFades:Array = [];
		private var itemsPanFades:Array = [];

		private var timer:Timer;
		private var before:Number;


		public function initialize():void
		{
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, run);
			timer.start();

			before = getTime();
		}

		public function add(item:IAudioItem):void
		{
			items[item.uid] = item;
		}

		public function getItemById(uid:int):IAudioItem
		{
			return items[uid];
		}

		private function getTime():Number
		{

			var date:Date = new Date()
			return date.getTime();
		}

		private function run(event:TimerEvent):void
		{
			var now:Number = getTime();
			var elapsed:Number = now - before;
			before = now;

			for each (var item:IAudioItem in items)
			{

				if (item is Track && !(item as Track).active)
					continue;

				if (item is Track && (item as Track).fadeAtEnd && (item as Track).duration != 0 && !isNaN((item as Track).duration))
				{
					if (!itemsVolFades[item.uid] || !itemsVolFades[item.uid].oE)
					{
						var pos:Number = (item as Track).duration - Mixer.DURATION_TRANSITIONS;

						if ((item as Track).positionMs >= pos)
						{
							itemsVolFades[item.uid] = new Fade(Mixer.DURATION_TRANSITIONS, item.volume, 0, false, item.clear, true);
							(item as Track).notifyEndFadeStart();
						}
					}
				}

				var fade:Fade;

				if (itemsVolFades[item.uid])
				{
					fade = itemsVolFades[item.uid] as Fade;
					var v:Number = fade.getCurrentValue(now);

					(fade.keepChanges) ? item.volume = v : item.setVolume(v);
					if (fade.over)
						volumeToDone(item.uid);
				}
				if (itemsPanFades[item.uid])
				{
					fade = itemsPanFades[item.uid] as Fade;
					var p:Number = fade.getCurrentValue(now);
					(fade.keepChanges) ? item.pan = p : item.setPan(p);
					if (fade.over)
						panToDone(item.uid);
				}

			}
		}

		public function volumeTo(uid:int, t:Number, s:Number, e:Number, k:Boolean, callback:Function):void
		{
			(k) ? items[uid].volume = s : items[uid].setVolume(s);
			itemsVolFades[uid] = new Fade(t, s, e, k, callback);
		}

		public function panTo(uid:int, t:Number, s:Number, e:Number, k:Boolean):void
		{
			(k) ? items[uid].pan = s : items[uid].setPan(s);
			itemsPanFades[uid] = new Fade(t, s, e, k);
		}

		public function volumeToDone(uid:int):void
		{
			var fade:Fade = itemsVolFades[uid] as Fade;
			if (fade.callback is Function)
				fade.callback();

			killVolumeTo(uid);
		}

		public function panToDone(uid:int):void
		{
			itemsPanFades[uid] = undefined;
		}

		public function killVolumeTo(uid:int):void
		{
			itemsVolFades[uid] = undefined;
		}

	}

}



