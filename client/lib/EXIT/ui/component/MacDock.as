package EXIT.ui.component
{
	import EXIT.util.DrawUtil;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MacDock extends Sprite
	{
		/* ********** REQUIRE PARAM ************/
		protected var vectorBtn					:Vector.<DisplayObject>;
		protected var spaceBtn					:Number;
		protected var numItemRender				:Number;
		protected var heightOverMc				:Number;
		//
		protected var vecStaticPos 				:Vector.<Number> = new Vector.<Number>();

		/* *********** AREA ********* */
		protected var overMc					:Sprite;
		private var overMcWidth					:Number;
		private var activateWidth				:Number;
		
		
		/* ******** SPANNING PARAM *************/
		protected var macDockVO					:MacDockVO = new MacDockVO();
		private var maxScaleOver				:Number = 1.5;
		private var spreadSpaceNum				:Number = .5; //how many spaceBtn spread to side when over
		private var scalingAreaSpaceNum			:Number = 2; //how many spaceBtn far from mouseX to active the btn
		// radius means width in only one side.
		private var spreadRadius				:Number;
		protected var activateAreaRadius		:Number;
		
		//// debug
//		protected var debugMc:Sprite;
		
		public function MacDock( $vectorBtn:Vector.<DisplayObject> , $spaceBtn:Number , $numItemRender:Number=0 , $heightOverMc:Number=0 )
		{
			super();
			vectorBtn = $vectorBtn;
			spaceBtn = $spaceBtn;
			numItemRender= $numItemRender ? $numItemRender : $vectorBtn.length-1;
			heightOverMc = $heightOverMc ? $heightOverMc : spaceBtn*maxScaleOver;
			
			activateWidth = scalingAreaSpaceNum*2*spaceBtn;
			activateAreaRadius = scalingAreaSpaceNum*spaceBtn;
			spreadRadius = spreadSpaceNum*spaceBtn;
			overMcWidth = (numItemRender+1)*spaceBtn; // >>>>>>> change this
			
			alignDefaultPosition();
			
			/* *********** DEBUG ******************** */
			/*debugMc = new Sprite();
			debugMc.graphics.beginFill(0xff0000,0);
			debugMc.graphics.drawRect( -activateWidth/2 , -spaceBtn , activateWidth , spaceBtn );
			debugMc.graphics.endFill();
			addChild(debugMc);*/
			
			
			/* *********** OVER AREA ****************** */
			overMc = new Sprite();
			overMc.graphics.beginFill(0x000000,0.1);
			overMc.graphics.drawRect(-overMcWidth*.5 ,-heightOverMc , overMcWidth , heightOverMc );
			overMc.graphics.endFill();
			addChild(overMc);
			
			overMc.addEventListener(MouseEvent.ROLL_OVER , startOver );
			overMc.addEventListener(MouseEvent.ROLL_OUT , startOut );
			
			macDockVO.maxScaleOver = 1;
			macDockVO.spreadRadius = 0;
		}
		
		protected function alignDefaultPosition():void
		{
			for( var i:uint=0 ; i<=vectorBtn.length-1 ; i++ ){
				vectorBtn[i].x = spaceBtn * i - ( numItemRender*spaceBtn*.5 );
				addChild(vectorBtn[i]);
				vecStaticPos[i] = vectorBtn[i].x;
				/* *********** DEBUG ******************** */
				var d:Sprite = DrawUtil.getRect(10,10);
				d.x = vecStaticPos[i]-5;
				addChild(d);
			}
		}
		
		protected function startOver(event:MouseEvent):void
		{
			TweenLite.to( macDockVO , .2 , { maxScaleOver:maxScaleOver , spreadRadius:spreadRadius } );
			addEventListener(Event.ENTER_FRAME , updateOverPostion );
		}		
		
		protected function startOut(event:Event):void
		{
			TweenLite.to( macDockVO , .2 , { maxScaleOver:1 , spreadRadius:0 , onComplete:function():void{
				removeEventListener(Event.ENTER_FRAME , updateOverPostion );
			}} );
		}
		
		protected function updateOverPostion(event:Event):void
		{
//			debugMc.x=overMc.mouseX;
			var leftOverEdge:Number = overMc.mouseX - activateAreaRadius;
			var rightOverEdge:Number = overMc.mouseX + activateAreaRadius;
			var str:String = '';
			for( var i:uint=0 ; i<=vectorBtn.length-1 ; i++ ){
				if( vecStaticPos[i] - macDockVO.spreadRadius < leftOverEdge ){
					vectorBtn[i].x = vecStaticPos[i]- macDockVO.spreadRadius;
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = 1;
				}else if(vecStaticPos[i] + macDockVO.spreadRadius > rightOverEdge ){
					vectorBtn[i].x = vecStaticPos[i]+macDockVO.spreadRadius;
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = 1;
				}else{
					var xFromMouseX:Number = ( vecStaticPos[i]-overMc.mouseX )*(macDockVO.spreadRadius/activateAreaRadius +1);
					var angle:Number = (xFromMouseX/activateAreaRadius)*(Math.PI*.5);
					vectorBtn[i].x = vecStaticPos[i]+macDockVO.spreadRadius*Math.sin(angle);
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = Math.cos(angle)*(macDockVO.maxScaleOver-1)+1;
					addChildAt(vectorBtn[i],numChildren-3);
					str += ''+(xFromMouseX/activateAreaRadius)+'  :  ';
				}
			}
			trace(macDockVO.maxScaleOver,maxScaleOver , ' : ' , macDockVO.spreadRadius , spreadRadius );
		}
	}
}

class MacDockVO
{
	public var maxScaleOver:Number;
	public var spreadRadius:Number;
}