package net.area80.ui.component
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import net.area80.ui.skin.PageNavigatorSkin;
	import net.area80.ui.skin.PageNumberSkin;
	
	import org.osflash.signals.Signal;

	public class PageNavigator extends Sprite
	{
		private var skin:PageNavigatorSkin;
		private var totalPage:uint;
		private var space:Number;
		
		private var _nowPage:uint;
		private var pageNumberVector:Vector.<PageNumberSkin>;
		private var buttonIdDict:Dictionary;
		
		public var SIGNAL_CHANGE_PAGE:Signal;
		public function PageNavigator($skin:PageNavigatorSkin,$totalPage:Number,$space:Number = 10)
		{
			skin = $skin;
			totalPage = $totalPage;
			space = $space;
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(Event.REMOVED_FROM_STAGE,dispose);
			/*var */
			buttonIdDict = new Dictionary();
			SIGNAL_CHANGE_PAGE = new Signal(uint);			
			/*assign*/
			addChild(skin);
			generatePageNumber();
			skin.nextButton.addEventListener(MouseEvent.CLICK,nextPage);
			skin.backButton.addEventListener(MouseEvent.CLICK,prevPage);
			skin.nextButton.buttonMode = true;
			skin.backButton.buttonMode = true;
			skin.nextButton.mouseChildren =false;
			skin.backButton.mouseChildren =false;
			/*init*/
			_nowPage = 0;
			gotoPage(1);
		}
		private function generatePageNumber():void
		{
			pageNumberVector = new Vector.<PageNumberSkin>();
			for(var i:uint = 0;i<=totalPage-1;i++){
				pageNumberVector.push(skin.getPageNumberButton);				
				alignButton(i);
				addChild(pageNumberVector[i]);
				buttonIdDict[pageNumberVector[i]] = i;
				pageNumberVector[i].addEventListener(MouseEvent.CLICK,numberPageClick);
				pageNumberVector[i].buttonMode = true;
				pageNumberVector[i].mouseChildren =false;
			}
		}
		private function alignButton(id:uint):void
		{
			// use for to sum all button width cause some times text may be wider than the others.
			var sumPageNumberWidth:Number = 0;
			for(var i:uint = 0; i< id;i++){
				sumPageNumberWidth += pageNumberVector[i].width;
			}
			pageNumberVector[id].x = skin.backButton.x + skin.backButton.width + space*(id+1) + sumPageNumberWidth;
			pageNumberVector[id].numText.text = String(id+1);
			if(id == totalPage-1){
				skin.nextButton.x = pageNumberVector[id].x + pageNumberVector[id].width + space;
			}
		}
		private function numberPageClick(e:MouseEvent):void
		{
			gotoPage(int(buttonIdDict[e.currentTarget])+1);			
		}
		private function gotoPage(pageNumber:uint):void
		{			
			if(pageNumber != _nowPage){
				/*check next back btn visible*/
				if(pageNumber == 1 && skin.backButton.visible){
					skin.backButton.visible = false;
				}else if(!skin.backButton.visible){
					skin.backButton.visible = true;
				}
				if(pageNumber == totalPage && skin.nextButton.visible){
					skin.nextButton.visible = false;
				}else if(!skin.nextButton.visible){
					skin.nextButton.visible = true;
				}
				if(_nowPage != 0)
					pageNumberVector[(_nowPage-1)].gotoAndStop(1);
				_nowPage = pageNumber;
				pageNumberVector[(_nowPage-1)].gotoAndStop(2);
				
				
				SIGNAL_CHANGE_PAGE.dispatch(pageNumber);
			}
		}
		private function nextPage(e:MouseEvent):uint
		{
			gotoPage(_nowPage+1);
			return _nowPage;
		}
		private function prevPage(e:MouseEvent):uint
		{
			gotoPage(_nowPage-1);
			return _nowPage;
		}
		
		
		private function dispose(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
	}
}