package net.area80.component.composer.inputform
{

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	import net.area80.component.composer.core.IComposerComponent;
	import net.area80.utils.StringUtils;

	import org.osflash.signals.Signal;

	public class TextInput implements IComposerComponent
	{

		public var autoTrim:Boolean = true;

		public var SIGNAL_ONPRESSENTER:Signal = new Signal(TextInput);
		public var SIGNAL_CHANGE:Signal = new Signal(TextInput);

		private var _skin:TextInputSkin;
		private var _tf:TextField;
		private var _fieldBG:MovieClip;
		private var _enabled:Boolean = true;
		private var _defaultMessage:String = "";
		private var _isFocus:Boolean = false;
		private var multiline:Boolean = true;
		private var initMessage:String = "";
		private var isInit:Boolean = false;

		/**
		 *
		 * @param $skin
		 * @param $defaultMessage This will display if the field is empty.
		 * @param $initMessage Initial mess
		 * @param $multiline
		 *
		 */
		public function TextInput($skin:TextInputSkin, $defaultMessage:String = "", $initMessage:String = "", $multiline:Boolean = false)
		{

			_skin = $skin;
			_tf = _skin.textField;
			_fieldBG = _skin.backgroundClip;

			initMessage = $initMessage;
			_defaultMessage = $defaultMessage;

			if (initMessage == "")
				this.initMessage = _defaultMessage;
			_tf.addEventListener(Event.CHANGE, changeHandler);
			this.multiline = multiline;


			if (_fieldBG)
				_fieldBG.gotoAndStop(1);

			if (!_tf.stage) {
				_tf.addEventListener(Event.ADDED_TO_STAGE, initTextListener);
			} else {
				initTextListener();
			}
			super();

		}



		public function reset():void
		{
			_tf.text = _defaultMessage;
		}

		public function setText(t:String):void
		{
			if (t == "")
				return;
			if (!isInit)
				initMessage = t;
			_tf.text = (multiline) ? t : StringUtils.initHTMLString(t, false);
		}

		public function get value():*
		{
			return (trim(_tf.text) == trim(_defaultMessage)) ? "" : trim(_tf.text);
		}

		public function focus():void
		{
			_tf.stage.focus = _tf;
			//_tf.setSelection(0, _tf.text.length);
		}


		public function set enabled(b:Boolean):void
		{
			if (b != _enabled) {
				if (b) {
					if (_fieldBG)
						_fieldBG.gotoAndStop(((_isFocus) ? 2 : 1));
					_tf.mouseEnabled = true;
				} else {
					if (_fieldBG && _fieldBG.totalFrames > 2)
						_fieldBG.gotoAndStop(3);
					_tf.mouseEnabled = false;
				}
			}
			_enabled = b;

		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function dispose():void
		{
			removeTextListener();
		}

		public function get skin():DisplayObject
		{
			return _skin;
		}

		public function get skinAsTextInputSkin():TextInputSkin
		{
			return _skin as TextInputSkin;
		}

		protected function changeHandler(e:Event):void
		{
			if (!multiline) {

				_tf.text = StringUtils.initHTMLString(_tf.text, false);
			}
			SIGNAL_CHANGE.dispatch(this);
		}

		protected function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER) {
				if (!multiline) {
					_tf.stage.focus = null;
				}
				SIGNAL_ONPRESSENTER.dispatch(this);
			}
		}

		protected function initTextListener(e:Event = null):void
		{
			_tf.text = initMessage;
			_tf.cacheAsBitmap = true;
			_tf.alpha = _skin.focusAlpha;

			_tf.addEventListener(FocusEvent.FOCUS_IN, doFocus);
			_tf.addEventListener(FocusEvent.FOCUS_OUT, doFocus);
			isInit = true;

			_tf.addEventListener(Event.REMOVED_FROM_STAGE, removeTextListener);
		}

		protected function removeTextListener(e:Event = null):void
		{
			_tf.removeEventListener(FocusEvent.FOCUS_IN, doFocus);
			_tf.removeEventListener(FocusEvent.FOCUS_OUT, doFocus);
			_tf.removeEventListener(Event.REMOVED_FROM_STAGE, removeTextListener);
			if (_tf.stage)
				_tf.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_tf.addEventListener(Event.ADDED_TO_STAGE, initTextListener);
		}


		protected function trim(msg:String):String
		{
			return (autoTrim) ? StringUtils.trim(msg) : msg;
		}

		protected function doFocus(e:Event):void
		{
			_isFocus = (e.type == FocusEvent.FOCUS_IN);
			if (_isFocus) {
				if (trim(_tf.text) == trim(_defaultMessage)) {
					_tf.text = "";
				}
				_tf.alpha = 1;
				_tf.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			} else {
				if (trim(_tf.text) == "") {
					_tf.text = trim(_defaultMessage);
					_tf.cacheAsBitmap = true;
					_tf.alpha = _skin.focusAlpha;
				}
				_tf.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
			if (_fieldBG) {
				_fieldBG.gotoAndStop(((_isFocus) ? 2 : 1));
			}
		}



	}
}
