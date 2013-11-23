package net.area80.ui.component
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import net.area80.ui.skin.TextInputSkin;
	import net.area80.utils.StringUtils;
	
	import org.osflash.signals.Signal;

	public class TextInput extends Sprite
	{
		private var textInputSkin:TextInputSkin;
		private var defaultMessage:String;
		private var initMessage:String;
		
		public var autoTrim:Boolean = true;
		public var SIGNAL_ONPRESSENTER:Signal;
		public var SIGNAL_ONCHANGE_TEXT:Signal;
		
		//textField:DisplayObject, defaultMessage:String="", initMessage:String="", fieldBG:DisplayObject = null, multiline:Boolean=false)
		public function TextInput(textInputSkin:TextInputSkin, initMessage:String = "",defaultMessage:String="")
		{
			this.textInputSkin = textInputSkin;
			this.defaultMessage = defaultMessage;
			this.initMessage = initMessage;
			
			if(textInputSkin.clearBtn){
				textInputSkin.clearBtn.addEventListener(MouseEvent.CLICK,resetHandler);
			}
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(Event.REMOVED_FROM_STAGE,dispose,false,0,true);
			textInputSkin.inputText.addEventListener(FocusEvent.FOCUS_IN,focusIn,false,0,true);
			textInputSkin.inputText.addEventListener(FocusEvent.FOCUS_OUT,focusOut,false,0,true);
			textInputSkin.inputText.addEventListener(Event.CHANGE,textChangeDispatcher);
			SIGNAL_ONPRESSENTER = new Signal(TextInput);
			SIGNAL_ONCHANGE_TEXT = new Signal(TextInput,String);
						
			setDefaultMessage(defaultMessage);
			
			if(initMessage != ""){
				textInputSkin.inputText.text = initMessage;
				textInputSkin.inputText.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
			}
			
			textInputSkin.inputText.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
			
			addChild(textInputSkin);
			
		}
		private function focusIn(e:FocusEvent):void
		{
			textInputSkin.textBg.nextFrame();
			
			setDefaultMessage("");
			addEventListener(KeyboardEvent.KEY_UP,enterDispatcher,false,0,true);
		}
		private function focusOut(e:FocusEvent):void
		{
			textInputSkin.textBg.prevFrame();
			
			if(textInputSkin.inputText.text == ""){
				setDefaultMessage(defaultMessage);
			}
			removeEventListener(KeyboardEvent.KEY_UP,enterDispatcher);
		}
		private function textChangeDispatcher(e:Event):void
		{
			SIGNAL_ONCHANGE_TEXT.dispatch(this,e.target.text);
			if(textInputSkin.clearBtn){
				if(textInputSkin.inputText.text == ""){
					textInputSkin.clearBtn.gotoAndStop(1);
				}else{
					textInputSkin.clearBtn.gotoAndStop(2);
				}
			}
		}
		private function enterDispatcher(e:KeyboardEvent):void
		{
			SIGNAL_ONPRESSENTER.dispatch(this);
		}
		private function resetHandler(e:MouseEvent):void
		{
			value = "";
		}
		private function setDefaultMessage(msg:String):void
		{
			if(defaultMessage != "" && textInputSkin.defaultText){
				textInputSkin.defaultText.text = msg;
			}
		}
		private function trim (msg:String):String {
			return (autoTrim) ? StringUtils.trim(msg) : msg;
		}
		
		
		public function get value ():* {
			return trim(textInputSkin.inputText.text);
		}
		public function set value (msg:String):void{
			textInputSkin.inputText.text = msg;
			textInputSkin.inputText.dispatchEvent(new Event(Event.CHANGE));
		}
		public function reset ():void {
			textInputSkin.inputText.text = initMessage;
		}
		
		private function dispose(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
	}
}