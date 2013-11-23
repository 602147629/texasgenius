package EXIT.ui.component
{
	import EXIT.util.DrawUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MenuMac_old extends Sprite
	{
		private var vectorBtn										:Vector.<DisplayObject>;
		private var spaceBtn										:Number;
		private var numItemRender									:Number;
		
		private var	overMc											:Sprite;
		private var _overAreaWidth									:Number;
		private var halfOverAreaWidth								:Number;
		private var _clippingWidth									:Number;
		private var halfClippingWidth								:Number;
		private var _scaleOver										:Number = 1.5;
		// spread is number of over spaceBtn in two side ( if =1 means left spread 1 spaceBtn right 1 spaceBtn )
		private var _spread											:Number = 1;
		private var spreadSpaceBtn									:Number;
		private var vecPositionDummy								:Vector.<Number> = new Vector.<Number>();
		private var dummyPositionWidth								:Number;
		private var halfDummyPositionWidth							:Number;
		private var maxOverScale									:Number;
		
		private var vecStaticPos									:Vector.<Number>;

		
		private var debugMc											:Sprite;
		
		public function MenuMac_old( $vectorBtn:Vector.<DisplayObject> , $spaceBtn:Number , $numItemRender:Number=0)
		{
			// TO DO ...			
			// 2. clipping show only item in showing area.
			
			vectorBtn = $vectorBtn;
			spaceBtn = $spaceBtn;
			numItemRender= $numItemRender ? $numItemRender : $vectorBtn.length-1;
			
			_overAreaWidth = (_spread*2+1)*spaceBtn;
			halfOverAreaWidth = _overAreaWidth*.5;
			
			_clippingWidth = numItemRender*spaceBtn + _overAreaWidth;
			dummyPositionWidth = (_clippingWidth - spaceBtn);
			halfDummyPositionWidth = dummyPositionWidth*.5;
			spreadSpaceBtn = dummyPositionWidth/numItemRender;
			halfClippingWidth = numItemRender*spaceBtn*.5;
			
			vecStaticPos = new Vector.<Number>();
			for( var i:uint=0 ; i<=vectorBtn.length-1 ; i++ ){
				vectorBtn[i].x = spaceBtn * i - halfClippingWidth;
				addChild(vectorBtn[i]);
				vecStaticPos[i] = vectorBtn[i].x;
				
				vecPositionDummy.push( spreadSpaceBtn * i - halfDummyPositionWidth );
				
				var d:Sprite = DrawUtil.getRect(10,10);
				d.x = vecStaticPos[i]-5;
				addChild(d);
			}
			
			debugMc = new Sprite();
			debugMc.graphics.beginFill(0xff0000,.2);
			debugMc.graphics.drawRect( -halfOverAreaWidth , -100 , halfOverAreaWidth*2 , 100 );
			debugMc.graphics.endFill();
			addChild(debugMc);
			
			overMc = new Sprite();
			overMc.graphics.beginFill(0x000000,.2);
			overMc.graphics.drawRect(-_clippingWidth*.5 ,-100 , _clippingWidth , 100 );
			overMc.graphics.endFill();
			addChild(overMc);
			overMc.addEventListener(MouseEvent.ROLL_OVER , startOver );
			overMc.addEventListener(MouseEvent.ROLL_OUT , startOut );
		}
		
		protected function startOver(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME , updateOverPostion );
		}		
		
		protected function startOut(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME , updateOverPostion );
			for( var i:uint=0 ; i<=vectorBtn.length-1 ; i++ ){
				vectorBtn[i].x = spaceBtn * i - halfClippingWidth;
			}
		}
		
		protected function updateOverPostion(event:Event):void
		{
			debugMc.x=overMc.mouseX;
			var leftOverEdge:Number = overMc.mouseX - halfOverAreaWidth;
			var rightOverEdge:Number = overMc.mouseX + halfOverAreaWidth;
			var str:String = '';
			for( var i:uint=0 ; i<=vectorBtn.length-1 ; i++ ){
				if( vecStaticPos[i] - halfOverAreaWidth < leftOverEdge ){
					vectorBtn[i].x = vecStaticPos[i]- halfOverAreaWidth;
//					vectorBtn[i].x = vecPositionDummy[i];
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = 1;
//					vectorBtn[i].alpha = 1;
				}else if(vecStaticPos[i] + halfOverAreaWidth > rightOverEdge ){
					vectorBtn[i].x = vecStaticPos[i]+halfOverAreaWidth;
//					vectorBtn[i].x = vecPositionDummy[i];
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = 1;
//					vectorBtn[i].alpha = 1;
				}else{
//					vectorBtn[i].alpha = .4;
//					
					var xFromMouseX:Number = vecStaticPos[i]-overMc.mouseX;
					/*if( vecStaticPos[i]+halfOverAreaWidth > overMc.mouseX ){
						xFromMouseX = vecStaticPos[i]+halfOverAreaWidth - overMc.mouseX;
					}else if( vecStaticPos[i]-halfOverAreaWidth < overMc.mouseX ){
						xFromMouseX = vecStaticPos[i]-halfOverAreaWidth - overMc.mouseX;
					}else{
						xFromMouseX = 0;
					}*/
					var angle:Number = (xFromMouseX/halfOverAreaWidth)*(Math.PI*.5);
					vectorBtn[i].x = overMc.mouseX+halfOverAreaWidth*Math.sin(angle);
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = Math.cos(angle)*(_scaleOver-1)+1;
					addChildAt(vectorBtn[i],numChildren-3);
					str += ''+(halfOverAreaWidth*Math.sin(angle))+'  :  ';
//					vectorBtn[i].x = vecPositionDummy[i];
				}
			}
				trace(str);
		}
		
		/* ********  GET SET **************/
		public function get scaleOver():Number { return _scaleOver; }
		public function set scaleOver(value:Number):void
		{
			_scaleOver = value;
		}

	}
}