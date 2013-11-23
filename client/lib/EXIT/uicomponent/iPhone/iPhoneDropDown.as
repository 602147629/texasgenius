package EXIT.uicomponent.iPhone
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import net.area80.ui.component.Dropdown;
	
	import org.osflash.signals.Signal;
	
	public class iPhoneDropDown
	{
		public var signalSelected				:Signal
		public var nowIdSelected				:int;
		private var dropMc							:Sprite;
		private var skin								:MovieClip;
		private var vectorItem						:Vector.<MovieClip>;
		private var dictItem							:Dictionary;

		private var ipp									:iPhonePage;
		private var nowOver						:MovieClip;
		private var selectedBmp					:Bitmap;
		
		public function iPhoneDropDown( $skin:MovieClip , $vectorItem:Vector.<MovieClip> , $dropWidth:Number , $dropHeight:Number , $autoSelected:int = 0 )
		{
			super();
			skin = $skin;
			skin.gotoAndStop(1);
			vectorItem = new Vector.<MovieClip>();
			dictItem = new Dictionary();
			dropMc = new Sprite();
			skin.addEventListener(MouseEvent.CLICK , openMe );
			skin.buttonMode = true;
			
			for( var i:uint=0 ; i<= $vectorItem.length-1 ; i++ ){
				addItem( $vectorItem[i] );
			}
			ipp = new iPhonePage( $dropWidth , $dropHeight  );
			ipp.container = dropMc;
			skin.addChild( ipp );
			ipp.visible = false;
			
			signalSelected = new Signal( int );
			
			nowOver = $vectorItem[ $autoSelected ];
			mu(null);
			skin.stage.addEventListener( Event.REMOVED_FROM_STAGE , dispose );
		}
		
		protected function dispose(event:Event):void
		{
			skin.stage.removeEventListener( MouseEvent.MOUSE_MOVE , mm );
			skin.stage.addEventListener(MouseEvent.CLICK , closeMe );
		}
		
		//////////////////////////////////////// ITEM ////////////////////////////////////////////////////////////////////////	
		private function addItem( $mc :MovieClip ):void
		{
			$mc.addEventListener( MouseEvent.MOUSE_DOWN , md );
			dropMc.addChild( $mc );
			vectorItem.push( $mc );
			dictItem[ $mc ] = vectorItem.length-1;
		}
		
		protected function md(event:MouseEvent):void
		{
			nowOver = MovieClip(event.currentTarget);
			nowOver.nextFrame();
			nowOver.addEventListener(MouseEvent.MOUSE_UP , mu );
			skin.stage.addEventListener( MouseEvent.MOUSE_MOVE , mm );
		}
		
		protected function mu(event:MouseEvent):void
		{
			nowIdSelected = dictItem[nowOver];
			signalSelected.dispatch( nowIdSelected );
			mm(event);
			
			if(selectedBmp){
				skin.removeChild(selectedBmp);
				selectedBmp.bitmapData.dispose();
			}
			var bmpd:BitmapData = new BitmapData( nowOver.width , nowOver.height );
			bmpd.draw(nowOver);
			selectedBmp = new Bitmap(bmpd);
			skin.addChild(selectedBmp);
		}
		
		protected function mm(event:MouseEvent):void
		{
			nowOver.removeEventListener(MouseEvent.MOUSE_UP , mu );
			skin.stage.removeEventListener( MouseEvent.MOUSE_MOVE , mm );
			nowOver.gotoAndStop(1);
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		protected function openMe(event:MouseEvent):void
		{
			skin.removeEventListener(MouseEvent.CLICK , openMe );
			skin.stage.addEventListener(MouseEvent.CLICK , closeMe );
			event.stopPropagation();
			skin.gotoAndStop( 2 );
			skin.buttonMode = false;
			ipp.visible = true;
			skin.addChildAt(ipp,	skin.numChildren-1);
			
		}
		
		protected function closeMe(event:MouseEvent):void
		{
			trace('click'+event.currentTarget);
			if(event.currentTarget != this){
				close(event);
			}else{
				event.stopPropagation();
			}		
		}
		
		private function close(event:Event):void
		{
			trace('close ... '+skin.name);
			ipp.visible = false;
			skin.gotoAndStop( 1 );
			skin.buttonMode = true;
			skin.addEventListener(MouseEvent.CLICK , openMe );
			if(selectedBmp) skin.addChild(selectedBmp);  ///// swap depth to the top when gotoAndStop(1);
			skin.stage.removeEventListener(MouseEvent.CLICK , closeMe );
			event.stopPropagation();
		}
	}
}