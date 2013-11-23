package net.area80.ui.component
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	public class UIDataGrid extends MovieClip
	{
		private var content:MovieClip;
		private var _itemList:Array;
		//private var _dataList:Array;
		private var _row:uint;
		private var _spacing:uint;
		private var _horizontal:Boolean;
		public var SIGNAL_ITEM_CLICK:Signal;
		private var dataDict:Dictionary;
		
		public function UIDataGrid($row:uint,$spacing:uint,$horizontal:Boolean = true)
		{
			SIGNAL_ITEM_CLICK = new Signal(Object);
			this._horizontal = $horizontal;
			this._row = $row;
			this._spacing = $spacing;
			//_dataList = new Array();
			_itemList = new Array();
			content = new MovieClip();
			addChild(content);
		}
		public function addItem($item:*,$data:Object=null):void{
			if(!dataDict) dataDict = new Dictionary();
			dataDict[$item] = $data;
			//_dataList.push($data);
			_itemList.push($item);
		}
		public function removeItem():void{
			this._itemList = [];
			//	this._dataList = [];
			while(this.content.numChildren>0){
				content.removeChildAt(0);
			}
			
		}
		public function update():void{
			var i:uint = 0;
			while(i<_itemList.length){
				var item:* = _itemList[i];
				//item._data = _dataList[i];
				if(this._horizontal){
					item.x = (i%this._row)*(item.width+this._spacing);
					item.y = Math.floor(i/this._row)*(item.height+this._spacing);
				}else{
					item.y = (i%this._row)*(item.height+this._spacing);
					item.x = Math.floor(i/this._row)*(item.width+this._spacing);
				}
				item.addEventListener(MouseEvent.CLICK,onClickItem);
				content.addChild(item);
				i++;
			}
			
		}
		private function onClickItem(e:MouseEvent):void{
			SIGNAL_ITEM_CLICK.dispatch(dataDict[e.currentTarget]);
		}
		
	}
}