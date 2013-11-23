package net.area80.component.skinholder.scroller
{

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.area80.component.skinholder.core.SkinHolderComponent;
	import net.area80.ui.skin.ScrollBarSkin;

	public class VScrollbar extends SkinHolderComponent
	{
		private var scrollObject:DisplayObject;
		private var snapHeight:Number;
		private var cSnap:uint = 0;
		private var initPos:Number;
		private var _ratio:Number = 0;
		private var maskHeight:Number = 0;
		private var scrollbarskin:ScrollBarSkin;
		private var scrubberAutoSize:Boolean;

		public function VScrollbar(skin:ScrollBarSkin, scrollObject:DisplayObject, maskHeight:Number, snapHeight:Number = 1, scrubberAutoSize:Boolean = false)
		{
			super(skin);

			scrollbarskin = skin;

			this.scrubberAutoSize = scrubberAutoSize;
			this.snapHeight = snapHeight;
			this.scrollObject = scrollObject;
			this.maskHeight = maskHeight;

			initPos = scrollObject.y;
			scrollbarInit(scrollbarskin);

		}


		public function updateDisplay():void
		{
			if (totalSnap > showPerpage) {
				visible = true;
				scrollObject.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			} else {
				visible = false;
				scrollObject.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
		}

		public override function set height(h:Number):void
		{
			var btnHeight:Number = 0;
			if (scrollbarskin.arrowUp)
				btnHeight += scrollbarskin.arrowUp.height;
			if (scrollbarskin.arrowDown)
				btnHeight += scrollbarskin.arrowDown.height;
			scrollbarskin.bgScrollBar.height = h - btnHeight;
			positionSkin();
		}

		protected override function construct(e:Event = null):void
		{
			updateDisplay();
			addEventListener(Event.ENTER_FRAME, update);
			update();
			super.construct(e);
		}

		protected function positionSkin():void
		{
			if (scrollbarskin.arrowUp)
				scrollbarskin.arrowUp.y = 0;
			scrollbarskin.bgScrollBar.y = (scrollbarskin.arrowUp) ? scrollbarskin.arrowUp.y + scrollbarskin.arrowUp.height : 0;
			if (scrollbarskin.scrubber)
				scrollbarskin.scrubber.y = top;
			if (scrollbarskin.arrowDown)
				scrollbarskin.arrowDown.y = bottom;
		}

		private function scrollbarInit(skin:ScrollBarSkin):void
		{
			this.skin = skin;

			addChild(scrollbarskin.bgScrollBar);
			if (scrollbarskin.arrowUp)
				addChild(scrollbarskin.arrowUp);
			if (scrollbarskin.scrubber)
				addChild(scrollbarskin.scrubber);
			if (scrollbarskin.arrowDown)
				addChild(scrollbarskin.arrowDown);
			positionSkin();

			if (scrollbarskin.bgScrollBar)
				scrollbarskin.bgScrollBar.addEventListener(MouseEvent.MOUSE_DOWN, clickBarHandler);
			if (scrollbarskin.scrubber)
				scrollbarskin.scrubber.addEventListener(MouseEvent.MOUSE_DOWN, dragBarHandler);
			if (scrollbarskin.arrowUp)
				scrollbarskin.arrowUp.addEventListener(MouseEvent.CLICK, prevHandler);
			if (scrollbarskin.arrowDown)
				scrollbarskin.arrowDown.addEventListener(MouseEvent.CLICK, nextHandler);

		}


		public function get ratio():Number
		{
			return _ratio;
		}

		public function set ratio(r:Number):void
		{
			_ratio = Math.min(1, Math.max(0, r));
		}

		private function update(e:Event = null):void
		{
			var pos:Number = top + (ratio * (scrollbarskin.bgScrollBar.height - dragHeight));
			if (scrollbarskin.scrubber)
				scrollbarskin.scrubber.y += (pos - scrollbarskin.scrubber.y) * 0.3;
			if (scrollObject) {
				var oPos:Number = initPos - (Math.round(ratio * (totalSnap - showPerpage)) * snapHeight);
				scrollObject.y += (oPos - scrollObject.y) * 0.3;
			}
		}

		private function updateBySnap(s:Number):void
		{
			var t:Number = Math.ceil(totalSnap / showPerpage);
			ratio = (s / t);
		}


		private function nextHandler(e:MouseEvent = null):void
		{
			var t:Number = 4 * (1 / (totalSnap - showPerpage));
			ratio += t;
		}

		private function prevHandler(e:MouseEvent = null):void
		{
			var t:Number = 4 * (1 / (totalSnap - showPerpage));
			ratio -= t;
		}

		private function mouseWheelHandler(e:MouseEvent):void
		{
			ratio -= e.delta * 0.03;
			e.stopPropagation();
		}

		private function clickBarHandler(e:MouseEvent = null):void
		{
			ratio = (mouseY - top) / scrollbarskin.bgScrollBar.height;
		}

		private function dragBarHandler(e:MouseEvent = null):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}

		private function moveHandler(e:MouseEvent = null):void
		{
			var ty:Number = Math.min(bottom, Math.max(top, mouseY)) - top;
			ratio = ty / scrollbarskin.bgScrollBar.height;
		}

		private function stopDragHandler(e:MouseEvent = null):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}

		protected override function dispose(event:Event = null):void
		{
			addEventListener(Event.ADDED_TO_STAGE, construct);
			removeEventListener(Event.ENTER_FRAME, update);
			scrollObject.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			stopDragHandler();
			super.dispose(event);
		}

		private function get top():Number
		{
			return scrollbarskin.bgScrollBar.y;
		}

		private function get bottom():Number
		{
			return scrollbarskin.bgScrollBar.height + scrollbarskin.bgScrollBar.y;
		}

		private function get totalSnap():uint
		{
			return Math.ceil(scrollObject.height / snapHeight);
		}

		private function get showPerpage():uint
		{
			return Math.floor(maskHeight / snapHeight);
		}


		private function get dragHeight():Number
		{
			if (scrollbarskin.scrubber) {
				if (scrubberAutoSize) {
					scrollbarskin.scrubber.height = Math.max(0, Math.min(height, scrollbarskin.bgScrollBar.height * (maskHeight / scrollObject.height)));
				}
				return scrollbarskin.scrubber.height
			} else {
				return 0;
			}
			//return (scrollbarskin.scrubber) ? scrollbarskin.scrubber.height : 0;
		}

	}
}
