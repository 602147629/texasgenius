package module.gamepage
{
	import com.greensock.BlitMask;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import assets.m00_slotmachine_sp;
	
	public class SlotMachineComponent extends assets.m00_slotmachine_sp
	{
		
		private var _slotmachine:Sprite;
		private var _total:int = 100000;
		private var _bet:int = 0;
		private var _count:int = 0;
		private var _datas:Vector.<int>;
		 
		public function SlotMachineComponent()
		{
			x = 8.5;
			y = 474.75;
			/*_slotmachine = new assets.m00_slotmachine_sp;
			addChild(_slotmachine);*/
			
			var blitMask1:BlitMask = new BlitMask(strip1, strip1.x, strip1.y, strip1.width, 42.5, true, true, 0xffffff, true);
			var blitMask2:BlitMask = new BlitMask(strip2, strip2.x, strip2.y, strip2.width, 42.5, true, true, 0xffffff, true);
			var blitMask3:BlitMask = new BlitMask(strip3, strip3.x, strip3.y, strip3.width, 42.5, true, true, 0xffffff, true);
			var blitMask4:BlitMask = new BlitMask(strip4, strip4.x, strip4.y, strip4.width, 42.5, true, true, 0xffffff, true);
			var blitMask5:BlitMask = new BlitMask(strip5, strip5.x, strip5.y, strip5.width, 42.5, true, true, 0xffffff, true);
			
			spin_btn.addEventListener(MouseEvent.CLICK, onClickspin_btn);
			b_50_btn.addEventListener(MouseEvent.CLICK, onClickb_50_btn);
			b_100_btn.addEventListener(MouseEvent.CLICK, onClickb_100_btn);
			b_200_btn.addEventListener(MouseEvent.CLICK, onClickb_200_btn);
			
			top_tf.text = _total.toString();
			bet_tf.text = _bet.toString();
		}
		
		protected function onClickb_50_btn(event:MouseEvent):void
		{
			trace("50");
			updateBet(50);
		}
		
		protected function onClickb_100_btn(event:MouseEvent):void
		{
			trace("100");
			updateBet(100);
		}
		
		protected function onClickb_200_btn(event:MouseEvent):void
		{
			trace("200");
			updateBet(200);
		}
		
		protected function onClickspin_btn(event:MouseEvent):void
		{
			trace("sp");
			if (_bet <= 0)
				return;
			
			var i:int = 1;
			while (i <= 5)
			{
				if (!_datas)
					_datas = new Vector.<int>();
				
				var newNumber:Number = (randomNumber(0, 9) * 42.5) + 424.95;
				_datas.push(newNumber);
				
				TweenMax.to(getstrip("strip" + i), 3 + (i * .5), {y: strip1.y + newNumber, onComplete: onComplete});
				i++;
			}
		}
		
		/*private function get top_tf():TextField
		{
			return _slotmachine.getChildByName("top_tf") as TextField;
		}
		
		private function get bet_tf():TextField
		{
			return _slotmachine.getChildByName("bet_tf") as TextField;
		}
		
		private function get strip1():Sprite
		{
			return _slotmachine.getChildByName("strip1") as Sprite;
		}
		
		private function get strip2():Sprite
		{
			return _slotmachine.getChildByName("strip2") as Sprite;
		}
		
		private function get strip3():Sprite
		{
			return _slotmachine.getChildByName("strip3") as Sprite;
		}
		
		private function get strip4():Sprite
		{
			return _slotmachine.getChildByName("strip4") as Sprite;
		}
		
		private function get strip5():Sprite
		{
			return _slotmachine.getChildByName("strip5") as Sprite;
		}
		*/
		private function getstrip(name:String):Sprite
		{
			return getChildByName(name) as Sprite;
		}
		
		private function onComplete():void
		{
			_count++;
			
			if (_count >= 5)
			{
//				DebugUtil.trace("complete");
				
				var correct:int = 0;
				for each (var i:int in _datas)
				{
					if (_datas[0] == i)
						correct++;
				}
				
				if (correct >= 5)
					updateTotal(_bet);
				else
					updateTotal(_bet * -1);
				
				_bet = 0;
				bet_tf.text = _bet.toString();
				
				_datas = null;
			}
		}
		
		private function updateTotal(value:int):void
		{
			_total += value;
			top_tf.text = _total.toString();
		}
		
		private function updateBet(value:int):void
		{
			var totalBet:int = value + _bet;
			
			if (totalBet > _total)
				return;
			
			_bet = totalBet;
			bet_tf.text = _bet.toString();
		}
		
		private function randomNumber(min:Number, max:Number):Number
		{
			//good
			return Math.floor(Math.random() * (1 + max - min) + min);
		}
	}
}
