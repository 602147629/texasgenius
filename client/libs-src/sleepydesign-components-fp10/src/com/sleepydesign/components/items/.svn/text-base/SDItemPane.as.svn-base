package com.sleepydesign.components.items
{
	import com.sleepydesign.components.SDScrollPane;
	import com.sleepydesign.components.styles.SDItemPaneStyle;
	import com.sleepydesign.components.styles.SDSliderStyle;
	import com.sleepydesign.core.IIDObject;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.utils.MathUtil;
	import com.sleepydesign.utils.VectorUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.osflash.signals.Signal;

	public class SDItemPane extends SDSprite
	{
		protected var _style:SDItemPaneStyle;

		public function get prevButton():DisplayObject
		{
			return _style.prevButton;
		}

		public function get nextButton():DisplayObject
		{
			return _style.nextButton;
		}

		// canvas
		protected var _canvas:Sprite;
		protected var _scrollPane:SDScrollPane;

		public function get scrollPane():SDScrollPane
		{
			return _scrollPane;
		}

		private function get _pageSize():int
		{
			const iw:Number = _style.itemWidth;
			const ih:Number = _style.itemHeight;

			const pw:Number = _style.panelWidth;
			const ph:Number = _style.panelHeight;

			const colSize:int = pw / iw;
			const rowSize:int = ph / ih;

			return colSize * rowSize;
		}

		// signals
		private var _setPageSignal:Signal = new Signal;

		public function get setPageSignal():Signal
		{
			return _setPageSignal;
		}

		public function SDItemPane(_SDItemPaneStyle:SDItemPaneStyle)
		{
			this._style = _SDItemPaneStyle;

			// scroll pane
			addChild(_scrollPane = new SDScrollPane(_style));
			_scrollPane.useMouseWheel = false;
			_scrollPane.mouseEnabled = false;
			_scrollPane.slideCompleteSignal.add(onSlideComplete);
			_scrollPane.setSize(_style.panelWidth, _style.panelHeight);

			// slide -> page
			_scrollPane.vScrollBar.slideChangeSignal.add(onSlideChange);
			_scrollPane.hScrollBar.slideChangeSignal.add(onSlideChange);

			// content
			_scrollPane.addContent(_canvas = new Sprite);

			// nav
			if (prevButton && !prevButton.parent)
				addChild(prevButton);

			if (nextButton && !nextButton.parent)
				addChild(nextButton);

			if (prevButton)
				prevButton.name = "prevButton";

			if (nextButton)
				nextButton.name = "nextButton";

			// event
			addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onSlideChange(slidePercent:Number):void
		{
			var page:int = Math.ceil(slidePercent * totalPage);
			createPage(page, false, _style.useCulling);

			cullingItem();
		}

		//-------------------------------------------------------------

		public function get totalItems():int
		{
			return _itemDatas.length;
		}

		protected var _currentPageNum:int = -1;

		public function get currentPageNum():int
		{
			return _currentPageNum;
		}

		protected var _itemThumbs:Vector.<SDItemThumb>;

		public function get itemThumbs():Vector.<SDItemThumb>
		{
			return _itemThumbs;
		}

		protected var _itemDatas:Vector.<IIDObject>;

		public function get itemDatas():Vector.<IIDObject>
		{
			return _itemDatas;
		}

		public function set itemDatas(itemDatas:Vector.<IIDObject>):void
		{
			if (!itemDatas)
				return;

			// collect all data
			_itemDatas = itemDatas;

			// dispose view
			if (_itemThumbs)
				for each (var itemThumb:SDItemThumb in _itemThumbs)
					if (itemThumb)
						itemThumb.destroy();

			_itemThumbs = new Vector.<SDItemThumb>(totalItems);

			if (itemDatas.length <= 0)
				return;

			// draw page 0
			setPage(0, true);
		}

		// TODO : fix isCheckVisibility hack
		public function createPage(pageNum:int, forceReset:Boolean = false, isCheckVisibility:Boolean = true):void
		{
			if (pageNum < 0)
				pageNum = 0;

			if (pageNum > totalPage-1)
				pageNum = totalPage-1;
			
			// ignore if not dirty
			if (_currentPageNum == pageNum)
				if (!forceReset)
					return;
			
			const _itemDatas_length:int = _itemDatas.length;

			if (isCheckVisibility)
				_currentPageNum = pageNum;

			// current page -> next page
			if (_itemDatas && _itemDatas_length > 0)
			{
				const begIndex:int = pageNum > 0 ? (pageNum - 1) : 0;

				for (var i:int = begIndex * _pageSize; (i < (pageNum + 2) * _pageSize) && (i < _itemDatas_length); i++)
				{
					var itemData:IIDObject = _itemDatas[i] as IIDObject;

					// no data? skip then
					if (!itemData)
						continue;

					var itemThumb:SDItemThumb = _itemThumbs[i];

					// not create yet?
					if (!itemThumb)
						_itemThumbs[i] = itemThumb = addThumb(_style.setupThumb(itemData));

					// apply position
					setPositionByIndex(i, itemThumb);
				}
			}

			// nav
			if (isCheckVisibility)
			{
				_style.isPrevButtonEnable = (pageNum > 0);
				_style.isNextButtonEnable = (pageNum < totalPage - 1);
			}

			// scroll
			if (_style.orientation == SDSliderStyle.HORIZONTAL)
				_scrollPane.promissContentRect = new Rectangle(0, 0, getContentHeight(_itemDatas_length - 1), _style.itemHeight);
			else
				_scrollPane.promissContentRect = new Rectangle(0, 0, _style.itemWidth, getContentHeight(_itemDatas_length - 1));

			// culled
			cullingItem();
		}

		public function setPage(pageNum:int, forceReset:Boolean = false):void
		{
			// create page if need
			createPage(pageNum, forceReset);

			// scroll to current page num
			_scrollPane.scrollToPage(pageNum);

			// call when done setup
			setPageSignal.dispatch(pageNum);
		}

		public function resetPage():void
		{
			setPage(_currentPageNum, true);
		}

		public function addThumb(itemThumb:SDItemThumb):SDItemThumb
		{
			_canvas.addChild(itemThumb);
			return itemThumb;
		}

		public function removeThumb(itemThumb:SDItemThumb):void
		{
			if (!itemThumb)
				return;

			var index:uint = VectorUtil.removeItem(_itemThumbs, itemThumb);
			itemThumb.destroy();
		}

		public function removeAllThumb():void
		{
			for each (var itemThumb:SDItemThumb in _itemThumbs)
				itemThumb.destroy();
		}

		public function getThumbByID(thumbID:String):SDItemThumb
		{
			return VectorUtil.getItemByID(_itemThumbs, thumbID);
		}

		public function removeThumbByID(thumbID:String):void
		{
			removeThumb(getThumbByID(thumbID));
		}

		protected function setPositionByIndex(i:int, itemThumb:SDItemThumb):void
		{
			const iw:Number = _style.itemWidth;
			const ih:Number = _style.itemHeight;

			const pw:Number = _style.panelWidth;
			const ph:Number = _style.panelHeight;

			const colSize:int = pw / iw;
			const rowSize:int = ph / ih;

			const _thumbX:Number = i * iw;

			const colPos:Point = MathUtil.getPointFromIndex(i, colSize);
			const rowPos:Point = MathUtil.getPointFromIndex(i, rowSize);

			var pg:int;

			if (_style.orientation == SDSliderStyle.HORIZONTAL)
			{
				itemThumb.x = colPos.x * iw;
				itemThumb.y = colPos.y * ih;

				// auto warp
				if (colPos.y >= rowSize)
				{
					pg = int(colPos.y / rowSize);
					itemThumb.x = itemThumb.x + pw * pg;
					itemThumb.y = itemThumb.y % ph;
				}
			}
			else
			{
				itemThumb.x = colPos.x * iw;
				itemThumb.y = colPos.y * ih;

					// auto warp
					//if (colPos.y >= rowSize)
					//	itemThumb.x = itemThumb.x % pw;
			}

			//trace("i:" + (i + 1), itemThumb.x, itemThumb.y); //, colpage);

			//trace("--------------------");
		}

		private function getContentHeight(i:int):int
		{
			const iw:Number = _style.itemWidth;
			const ih:Number = _style.itemHeight;

			const pw:Number = _style.panelWidth;
			const ph:Number = _style.panelHeight;

			const colSize:int = pw / iw;
			const rowSize:int = ph / ih;

			var pos:Point;

			if (_style.orientation == SDSliderStyle.HORIZONTAL)
			{
				pos = MathUtil.getPointFromIndex(i, rowSize);
				return (pos.y * iw) + iw; //return (pos.y % rowSize) * ih + ih;
			}
			else
			{
				pos = MathUtil.getPointFromIndex(i, colSize);
				return (pos.y * ih) + ih;
			}
		}

		public function get totalPage():int
		{
			const pw:Number = _style.panelWidth;
			const ph:Number = _style.panelHeight;

			const wh:Number = getContentHeight(_itemDatas.length - 1);

			var result:int;
			if (_style.orientation == SDSliderStyle.HORIZONTAL)
			{
				result = Math.ceil(wh / pw);
			}
			else
			{
				result = Math.ceil(wh / ph);
			}

			return result;
		}

		// event handler

		/**return id*/
		public var thumbSignal:Signal = new Signal(String, MouseEvent);

		protected function onClick(event:MouseEvent):void
		{
			switch (event.target.name)
			{
				case "prevButton":
					if (_style.isPrevButtonEnable)
						prevPage();
					break;
				case "nextButton":
					if (_style.isNextButtonEnable)
						nextPage();
					break;
				default:
					// TODO: remove this hack
					if (event.target is SDItemThumb)
						thumbSignal.dispatch(SDItemThumb(event.target).id, event);
					else if (event.target.parent && event.target.parent is SDItemThumb)
						thumbSignal.dispatch(SDItemThumb(event.target.parent).id, event);
					else if (event.target.parent && event.target.parent.parent && event.target.parent.parent is SDItemThumb)
						thumbSignal.dispatch(SDItemThumb(event.target.parent.parent).id, event);
					break;
			}
		}

		public function prevPage():void
		{
			setPage(_currentPageNum - 1);
		}

		public function nextPage():void
		{
			setPage(_currentPageNum + 1);
		}

		private function onSlideComplete():void
		{
			cullingItem();
		}

		// TODO : optimize
		private function cullingItem():void
		{
			if (!_style.useCulling)
				return;

			const rect:Rectangle = _scrollPane.pixelBounds;

			var numCulled:int = 0;

			for each (var itemThumb:SDItemThumb in _itemThumbs)
			{
				if (!itemThumb)
					continue;

				if (_style.useCulling)
					itemThumb.culled = !rect.intersects(itemThumb.pixelBounds);
				else
					itemThumb.culled = false;

				if (itemThumb.culled)
					numCulled++;
			}
		}

		// Insert --------------------------------------------------------------------------------------

		public function pushData(idObject:IIDObject):void
		{
			if (!_itemDatas)
				throw new Error(" ! No _itemDatas");

			if (!_itemThumbs)
				throw new Error(" ! No _itemDatas");

			_itemDatas.push(idObject);
			var itemThumb:SDItemThumb;
			_itemThumbs.push(itemThumb = addThumb(_style.setupThumb(idObject)));

			const _itemDatas_length:int = _itemDatas.length;

			// apply position
			setPositionByIndex(_itemDatas_length - 1, itemThumb);

			// scroll
			if (_style.orientation == SDSliderStyle.HORIZONTAL)
				_scrollPane.promissContentRect = new Rectangle(0, 0, getContentHeight(_itemDatas_length - 1), _style.itemHeight);
			else
				_scrollPane.promissContentRect = new Rectangle(0, 0, _style.itemWidth, getContentHeight(_itemDatas_length - 1));

			// culled
			cullingItem();
		}

		// DELETE --------------------------------------------------------------------------------------

		public function removeDataByID(id:String):void
		{
			if (!_itemDatas)
				throw new Error(" ! No _itemDatas");

			if (!_itemThumbs)
				throw new Error(" ! No _itemDatas");

			VectorUtil.removeItemByID(_itemDatas, id);
			//VectorUtil.removeItem(_itemThumbs, idObject.id);
			removeThumbByID(id);

			// TODO : _style.removeThumb(idObject);
		}

		public function draw():void
		{
			resetPage();
		}
	}
}
