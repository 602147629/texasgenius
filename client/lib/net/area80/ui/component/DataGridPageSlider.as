package net.area80.ui.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gs.TweenLite;
	
	import org.osflash.signals.Signal;

	public class DataGridPageSlider extends Sprite
	{
		/* recieve var*/
		private var row:uint;
		private var column:uint;
		private var dataGridWidth:Number
		//private var animated:Boolean;//check from maskWidth
		private var spacing:Number;
		private var autoMask:Boolean;
		/* new Object */
		private var nowDataGrid:UIDataGrid;
		private var nextDataGrid:UIDataGrid;
		private var vectorItem:Vector.<DisplayObjectContainer>;
		private var allDataGrid:Sprite;
		/* new Var */
		private var _currentPage:uint;
		private var _totalPage:uint;
		private var numPerPage:uint;		
		private var isTweening:Boolean;
		private var tempNextPage:int = -1;
		/* public var */
		public var duration:Number = .5;
		public var animateChangePage:Boolean;
		/* signal */
		public var SIGNAL_TWEEN_COMPLETE:Signal;
		
		/**
		 * 
		 * @param row
		 * @param column
		 * @param spacing
		 * @param dataGridWidth
		 * @param autoMask >>> under construction
		 * 
		 */		
		public function DataGridPageSlider(row:uint, column:uint, spacing:Number ,dataGridWidth:Number = 0, autoMask:Boolean =true)
		{
			this.row = row;
			this.column = column;
			this.dataGridWidth = dataGridWidth;
			this.spacing = spacing;
			this.autoMask = autoMask;
			
			animateChangePage = Boolean(dataGridWidth);
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		/***********************************************************
		 * INIT FUNCTION 
		 ***********************************************************/
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(Event.REMOVED_FROM_STAGE,dispose);
			/*** once call ***/			
			vectorItem = new Vector.<DisplayObjectContainer>();
			allDataGrid = new Sprite();
			addChild(allDataGrid);
			SIGNAL_TWEEN_COMPLETE = new Signal();
			isTweening = false;
			/*** init var ***/
			/*** init funcion ***/
		}
		private function setUpVals():void
		{
		}
		
		/***********************************************************
		 * CHANGE PAGE FUNCTION 
		 ***********************************************************/
		private function addPage(_pageNumber:uint):UIDataGrid
		{
			var uiDataGrid:UIDataGrid = new UIDataGrid(row,spacing);
			allDataGrid.addChild(uiDataGrid);
			
			var startId:uint = (_pageNumber-1)*numPerPage;
//			var endId:uint = (_pageNumber*numPerPage < vectorItem.length-1) ? _pageNumber*numPerPage -1 : vectorItem.length-1;
			var endId:uint = Math.min(vectorItem.length-1,startId+(row*column)-1);
			if(vectorItem.length != 0){
				for(var i:uint =startId;i<=endId;i++){
					uiDataGrid.addItem(vectorItem[i]);
				}
			}
			uiDataGrid.update();
			
			return uiDataGrid;
		}
		private function completeTween():void
		{
			trace("COMPLTE TWEEN");
			/*datatGrid*/
			allDataGrid.removeChild(nowDataGrid);
			nowDataGrid = nextDataGrid;
			nextDataGrid = null;
			
			/*back to stable position*/
			allDataGrid.x = 0;
			nowDataGrid.x = 0;
			/*signal*/
			SIGNAL_TWEEN_COMPLETE.dispatch();
			/*TWEEN*/
			isTweening = false;
			gotoPage(tempNextPage);
		}
		
		/***********************************************************
		 * PUBLIC FUNCTION 
		 ***********************************************************/
		/**
		 * 
		 * @param item DisplayObjectContainer 
		 * when added all item must call update() to execute the class
		 * 
		 */		
		public function addItem(item:DisplayObjectContainer):void
		{
			vectorItem.push(item);
		}
		public function gotoPage(_pageNumber:uint):uint
		{
			if(_pageNumber != _currentPage && _pageNumber >=1 && _pageNumber <= _totalPage){
				
				if(!isTweening){
					trace("_pageNumber ="+_pageNumber +" : _currentPage="+_currentPage);
					nextDataGrid = addPage(_pageNumber);
					/* arrange Position */
					var position:Number;
					if(_pageNumber > _currentPage){
						position = dataGridWidth+spacing;
						nextDataGrid.x = position;
					}else if(_pageNumber < _currentPage){
						position = -dataGridWidth-spacing;
						nextDataGrid.x = position;
					}
					
					/* animate */
					if(animateChangePage){
						trace("...."+dataGridWidth);
						TweenLite.to(allDataGrid,duration,{x:-position,onComplete:completeTween});
					}else{
						completeTween();
					}			
					isTweening = true;
					tempNextPage = 0;
					_currentPage = _pageNumber;
				}else{
					tempNextPage = _pageNumber;
				}
			}
			return _currentPage;
		}
		public function nextPage():uint
		{			
			return gotoPage(_currentPage+1);
		}
		public function prevPage():uint
		{			
			return gotoPage(_currentPage-1);
		}
		
		public function addItemVector($vectorItem:Vector.<DisplayObjectContainer>):void
		{
			for(var i:uint=0;i<=$vectorItem.length-1;i++){
				addItem($vectorItem[i]);
			}
		}
		
		public function resetItemVector():Vector.<DisplayObjectContainer>
		{
			return vectorItem = new Vector.<DisplayObjectContainer>();	
		}
		
		public function update(page:uint = 1):void
		{
			trace("***************** UPDATE ****************" + isTweening);
			/*reset*/
			TweenLite.killTweensOf(allDataGrid);			
			isTweening = false;
			if(nextDataGrid) allDataGrid.removeChild(nextDataGrid);
			if(nowDataGrid) allDataGrid.removeChild(nowDataGrid);			
			allDataGrid.x = 0;
			tempNextPage = 0;
			_currentPage = 1;
			
			/*update value*/
			numPerPage = row*column;
			_totalPage = Math.ceil(vectorItem.length / numPerPage);			
			nextDataGrid = null;
			nowDataGrid = addPage(1);
		}
		public function updateItemLength():void
		{
			numPerPage = row*column;
			_totalPage = Math.ceil(vectorItem.length / numPerPage);			
			if(_currentPage > _totalPage){
				gotoPage(_totalPage);
			}else{
				var tempAnimate:Boolean = animateChangePage;
				update(_currentPage);
				animateChangePage = tempAnimate;
			}
			
		}
		
		
		public function get currentPage():uint{return _currentPage;}
//		public function set currentPage(value:uint):void{}
		public function get totalPage():uint{return _totalPage;}
		
		/***********************************************************/
		
		
		
		private function dispose(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
	}
}