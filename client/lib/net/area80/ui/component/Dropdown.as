package net.area80.ui.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import net.area80.ui.skin.DropdownItemSkin;
	import net.area80.ui.skin.DropdownSkin;
	import net.area80.ui.skin.ScrollBarSkin;

	import org.osflash.signals.Signal;

	/*TO DO LIST
		1. scrollbar postion
		2. click stage to close*/
	public class Dropdown extends Sprite
	{
		public static const OPEN:String = "open";
		public static const CLOSE:String = "close";
		public var SIGNAL_SELECTED_ITEM:Signal;
		public var SIGNAL_EVENT:Signal = new Signal(String);


		public var itemBitmap:Bitmap;

		private var i:uint;

		public var dropdownSkin:DropdownSkin;
		public var scrollBarSkin:ScrollBarSkin;
		private var labelArray:Array;
		private var valueArray:Array;
		protected var itemArray:Array;
		private var itemSpace:Number;
		private var initSelection:int

		private var allDetail:Sprite;
		private var allItem:Sprite
		public var scrollbar:Scrollbar;
		private var dummyItemSkin:DropdownItemSkin;
		private var itemBitmapData:BitmapData;


		private var itemHeight:Number;

		protected var selectedId:int = -1;
		private var dictId:Dictionary;

		public function Dropdown(dropdownSkin:DropdownSkin, scrollBarSkin:ScrollBarSkin = null, labelArray:Array = null, valueArray:Array = null, itemSpace:Number = 2, initSelection:int = -1)
		{
			this.dropdownSkin = dropdownSkin;
			this.scrollBarSkin = scrollBarSkin;
			this.labelArray = labelArray;
			this.valueArray = valueArray;
			this.itemSpace = itemSpace
			this.initSelection = initSelection;

			this.x = dropdownSkin.x;
			this.y = dropdownSkin.y;
			dropdownSkin.x = 0;
			dropdownSkin.y = 0;

			SIGNAL_SELECTED_ITEM = new Signal(int);
			init();
			//addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		public function init(e:Event = null):void
		{
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, dispose, false, 0, true);

			dummyItemSkin = dropdownSkin.getItem();
			itemBitmapData = new BitmapData(dummyItemSkin.width, dummyItemSkin.height, true, 0x00000000);
			itemBitmap = new Bitmap(itemBitmapData, "auto", true);
			dropdownSkin.selectedLabel.addChild(itemBitmap);

			dictId = new Dictionary();

			addChild(dropdownSkin);
			initProperty();
			openClose();

			id = initSelection;
		}

		private function initProperty():void
		{
			itemArray = new Array();
			allDetail = new Sprite();
			allItem = new Sprite();
			addChild(allDetail);
			allDetail.addChild(allItem);
			if (labelArray) {
				if (valueArray) {
					for (i = 0; i<=labelArray.length-1; i++) {
						addItem({label: labelArray[i], value: (valueArray[i])?valueArray[i]:labelArray[i]}, -1, false);
					}
				} else {
					for (i = 0; i<=labelArray.length-1; i++) {
						addItem({label: labelArray[i], value: labelArray[i]}, -1, false);
					}
				}
			}

			var itemHeight:Number = dummyItemSkin.height+itemSpace;
			allItem.x = dropdownSkin.maskMc.x;
			allItem.y = dropdownSkin.maskMc.y;
			allItem.mask = dropdownSkin.maskMc;

			if (scrollBarSkin) {
				scrollbar = new Scrollbar(allItem, dropdownSkin.maskMc, scrollBarSkin, true, itemHeight, true);
				allDetail.addChild(scrollbar);
			}

			allDetail.visible = false;
		}

		/**
		 *
		 * @param obj
		 *   obj.label
		 *   obj.value (not require)
		 * @param index
		 * @param update
		 *
		 */
		public function addItem(obj:Object, index:int = -1, update:Boolean = true):void
		{

			var item:DropdownItemSkin = dropdownSkin.getItem();
			item.buttonMode = true;
			item.gotoAndStop(1);
			obj.item = item;
			allItem.addChild(item);
			if (index==-1) {
				index = itemArray.length;
			}



			if (index>itemArray.length) {
				throw(new Error("************ YOUR INDEX IS MORE THAN THE LENGTH OF ITEM ********"));
			} else {
				item.y = index*(item.height+itemSpace);
				item.setText(obj.label);
				if (obj.value) {
					item.setValue(obj.value);
				}
				itemArray.splice(index, 0, obj);
			}
//			trace("length:", itemArray.length, " value:", itemArray[index].value);
			dictId[item] = index;
			item.addEventListener(MouseEvent.CLICK, selected, false, 0, true);
			item.addEventListener(MouseEvent.ROLL_OVER, overItem, false, 0, true);
			item.addEventListener(MouseEvent.ROLL_OUT, outItem, false, 0, true);
		}

		public function addItemsByValue(_labelArray:Array, _valueArray:Array):void
		{
			if (_labelArray) {
				if (_valueArray) {
					for (i = 0; i<=_labelArray.length-1; i++) {
						addItem({label: _labelArray[i], value: (_valueArray[i])?_valueArray[i]:_labelArray[i]}, -1, false);
					}
				} else {
					for (i = 0; i<=_labelArray.length-1; i++) {
						addItem({_label: labelArray[i], value: _labelArray[i]}, -1, false);
					}
				}
			}
		}

		public function removeAllItem():void
		{
			for (var i:int = 0; i<=itemArray.length-1; i++) {
				allItem.removeChild(itemArray[i].item);
			}
			dictId = new Dictionary();
			itemArray = [];
		}

		private function selected(e:MouseEvent):void
		{
			if (selectedId!=-1) {
				itemArray[selectedId].item.gotoAndStop(1);
			}
//			var value:String = String(itemArray[dictId[e.currentTarget]].value);
			selectedId = dictId[e.currentTarget];
//			trace("selectedIdselectedIdselectedIdselectedId = "+itemArray[selectedId].value);

			dropdownSkin.selectedLabel.removeChild(itemBitmap);

			MovieClip(e.currentTarget).gotoAndStop(1);
			itemBitmapData.dispose();
			itemBitmapData = new BitmapData(Sprite(e.currentTarget).width, Sprite(e.currentTarget).height, true, 0x00000000);
			itemBitmapData.draw(Sprite(e.currentTarget), null, null, null, null, true);
			itemBitmap = new Bitmap(itemBitmapData, "auto", true);
			dropdownSkin.selectedLabel.addChild(itemBitmap);
			MovieClip(e.currentTarget).gotoAndStop(MovieClip(e.currentTarget).totalFrames);
			/*TextField(dropdownSkin.selectedLabel.getChildByName("textLabel")).text = value
			trace(TextField(dropdownSkin.selectedLabel.getChildByName("textLabel")).text);*/
			SIGNAL_SELECTED_ITEM.dispatch(selectedId);
			closeDropdown();
		}

		private function overItem(e:MouseEvent):void
		{
			e.currentTarget.gotoAndStop(2);
			allItem.setChildIndex(DisplayObject(e.currentTarget), allItem.numChildren-1);
		}

		private function outItem(e:MouseEvent):void
		{
			if (selectedId!=dictId[e.currentTarget]) {
				e.currentTarget.gotoAndStop(1);
			} else {
				e.currentTarget.gotoAndStop(MovieClip(e.currentTarget).totalFrames);
			}
		}

		private function openClose():void
		{
			dropdownSkin.dropButton.gotoAndStop(1);
			dropdownSkin.dropButton.buttonMode = true;
			dropdownSkin.dropButton.mouseChildren = false;
			dropdownSkin.dropButton.addEventListener(MouseEvent.CLICK, toggleOpen);
		}


		private function toggleOpen(e:MouseEvent):void
		{
			if (allDetail.visible) {
				// prevent error while clicking at scrollbar
				if (mouseX>0&&mouseX<dropdownSkin.background.x+dropdownSkin.background.width&&mouseY>0&&mouseY<dropdownSkin.background.y+dropdownSkin.background.height) {
					return;
				}
			}
			if (allDetail.visible) {
				closeDropdown();
			} else {
				openDropdown();
			}
			e.stopImmediatePropagation();
		}

		public function closeDropdown():void
		{
			if (allDetail.visible) {
				dropdownSkin.background.prevFrame();
				dropdownSkin.dropButton.prevFrame();
				allDetail.visible = false;

				stage.removeEventListener(MouseEvent.CLICK, toggleOpen);
				this.removeEventListener(MouseEvent.CLICK, toggleOpen);

				SIGNAL_EVENT.dispatch(CLOSE);
			}
		}

		public function openDropdown():void
		{
			if (!allDetail.visible) {
				this.parent.setChildIndex(this, this.parent.numChildren-1);
				dropdownSkin.background.nextFrame();
				dropdownSkin.dropButton.nextFrame();
				allDetail.visible = true;

				stage.addEventListener(MouseEvent.CLICK, toggleOpen);
				this.addEventListener(MouseEvent.CLICK, toggleOpen);

				SIGNAL_EVENT.dispatch(OPEN);
			}
		}


		/**
		 *PUBLIC FUNCTION
		 */
		public function get id():int
		{
			return selectedId;
		}

		public function set id($value:int):void
		{
			if ($value>-1&&$value<=itemArray.length-1) {
				itemArray[$value].item.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		public function get value():String
		{
			return itemArray[selectedId].value;
		}


		public function dispose(e:Event):void
		{
			itemBitmapData.dispose();
			removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			stage.removeEventListener(MouseEvent.CLICK, toggleOpen);
		}
	}
}
import net.area80.ui.skin.DropdownItemSkin;


class itemVar extends Object
{
	public var label:String;
	public var value:*;
	public var item:DropdownItemSkin;

	function itemVar()
	{

	}
}
