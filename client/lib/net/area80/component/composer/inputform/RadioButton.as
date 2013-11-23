package net.area80.component.composer.inputform
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	public class RadioButton
	{
		private var vectorButton:Vector.<MovieClip>;
		private var dictId:Dictionary;
		private var _selectedButtonId:int = -1;
		
		public var SIGNAL_CICK:Signal;
		public function RadioButton(vectorButton:Vector.<MovieClip>)
		{
			this.vectorButton = vectorButton;
			SIGNAL_CICK = new Signal(int);
			
			dictId = new Dictionary();
			
			for(var i:uint=0;i<=vectorButton.length-1;i++){
				vectorButton[i].gotoAndStop(1);
				dictId[vectorButton[i]] = i;
				MovieClip(vectorButton[i]).addEventListener(MouseEvent.CLICK,selected);
				vectorButton[i].buttonMode = true;
				vectorButton[i].mouseChildren = true;
			}
		}
		private function selected(e:MouseEvent):void
		{
			if(_selectedButtonId != -1){
				vectorButton[_selectedButtonId].prevFrame();
				_selectedButtonId = -1;
			}
			if(MovieClip(e.currentTarget).currentFrame == 2){
				e.currentTarget.prevFrame();
				_selectedButtonId = -1;
			}else{
				e.currentTarget.nextFrame();
				_selectedButtonId = dictId[e.currentTarget];
			}
			SIGNAL_CICK.dispatch(_selectedButtonId);
		}
		public function get value():int
		{
			return _selectedButtonId;
		}
		public function set value(_value:int):void
		{
			vectorButton[_value].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
	}
}