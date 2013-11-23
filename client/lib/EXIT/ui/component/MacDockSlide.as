package EXIT.ui.component
{
	import EXIT.math.MathStatic;
	import EXIT.util.DrawUtil;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * @author EXIT
	 * This extended class extend only to EXIT Filter project.
	 * 
	 */	
	final public class MacDockSlide extends MacDock
	{
		private var accelerationSlide			:Number = .2;
		private var frictionSlide				:Number = 2;
		private var maxVelocity					:Number = 10;
		
		private var moveVo						:MoveVO;
		private var endHalfOverMcWidth			:Number;
		private var margin_left					:Number=0;
		
		private var isMouseOver					:Boolean = false;
		private var isAnimateOutComplete		:Boolean = true;
		
		private var leftRightBtnWidth			:Number;
		
		public function MacDockSlide($vectorBtn:Vector.<DisplayObject>, $spaceBtn:Number, $numItemRender:Number=0, $heightOverMc:Number=0)
		{
			super($vectorBtn, $spaceBtn, $numItemRender, $heightOverMc);
			
			moveVo = new MoveVO();
			overMc.width = (numItemRender+4)*spaceBtn;
			endHalfOverMcWidth = ((numItemRender+2)*spaceBtn)*.5;
			leftRightBtnWidth = overMc.width*.5 - endHalfOverMcWidth;
			var endOverMc:Sprite = DrawUtil.getRect( endHalfOverMcWidth*2 , 100 );
			endOverMc.x = -endHalfOverMcWidth;
			endOverMc.y = - 100;
			addChildAt(endOverMc,0);
			endOverMc.alpha = .3;
				
//			trace( overMc.width, leftRightBtnWidth, endHalfOverMcWidth ,  numItemRender );
		}
		
		/*override protected function alignDefaultPosition():void
		{
			for( var i:uint=0 ; i<=vectorBtn.length-1 ; i++ ){
				vectorBtn[i].x = spaceBtn * (i) - ( numItemRender*spaceBtn*.5 );
				addChild(vectorBtn[i]);
				vecStaticPos[i] = vectorBtn[i].x;
			}
		}*/
		
		
		override protected function	startOver(event:MouseEvent):void
		{
			super.startOver(event);
			isMouseOver = true;
		}
		override protected function startOut(event:Event):void
		{
			TweenLite.to( macDockVO , .5 , { maxScaleOver:1 , spreadRadius:0 , onComplete:function():void{isAnimateOutComplete=true;} });
			isMouseOver = false;
			isAnimateOutComplete = false;
//			trace('_____________________________________');
		}
		
		override protected function updateOverPostion(event:Event):void
		{
			// move left , right
			/*if(isMouseOver){
				if( mouseX > endHalfOverMcWidth ){
					moveVo.velocity -= accelerationSlide;
					if( moveVo.velocity < -maxVelocity ){
						moveVo.velocity = -maxVelocity;
					}
					margin_left += moveVo.velocity;
				}else if( mouseX < -endHalfOverMcWidth ){
					moveVo.velocity += accelerationSlide;
					if( moveVo.velocity > maxVelocity ){
						moveVo.velocity = maxVelocity;
					}
					margin_left += moveVo.velocity;
				}else if( moveVo.velocity != 0 ){
					moveVo.velocity = MathStatic.approach0(moveVo.velocity , frictionSlide );
					margin_left += moveVo.velocity;
				}
			}else{
				moveVo.velocity = MathStatic.approach0(moveVo.velocity , frictionSlide );
				margin_left += moveVo.velocity;
				if( isAnimateOutComplete && !isMouseOver ){
					removeEventListener(Event.ENTER_FRAME , updateOverPostion );
				}
			}*/
//				trace('..'+moveVo.velocity);
			
			
			//  magnifier
//			debugMc.x=mouseX;
			var leftOverEdge:Number = mouseX - activateAreaRadius;
			var rightOverEdge:Number = mouseX + activateAreaRadius;
			var str:String = '';
			
			for( var i:uint=0 ; i<=vectorBtn.length-1 ; i++ ){
				
				//********* magnify **********//
				var newPos:Number =  vecStaticPos[i]+ margin_left;
				if( newPos - macDockVO.spreadRadius < leftOverEdge ){
					vectorBtn[i].x = newPos - macDockVO.spreadRadius;
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = 1;
				}else if( newPos + macDockVO.spreadRadius > rightOverEdge ){
					vectorBtn[i].x = newPos+macDockVO.spreadRadius;
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = 1;
				}else{
					var xFromMouseX:Number = ( newPos-mouseX )*(macDockVO.spreadRadius/activateAreaRadius +1);
					var angle:Number = (xFromMouseX/activateAreaRadius)*(Math.PI*.5);
					vectorBtn[i].x = newPos+macDockVO.spreadRadius*Math.sin(angle);
					vectorBtn[i].scaleX = vectorBtn[i].scaleY = Math.cos(angle)*(macDockVO.maxScaleOver-1)+1;
					addChildAt(vectorBtn[i],numChildren-3);
					str += ''+(xFromMouseX/activateAreaRadius)+'  :  ';
				}
				
				//********* alpha visible ********/
				var farScale:Number;
				if( vectorBtn[i].x > endHalfOverMcWidth ){
					if(vectorBtn[i].x < leftRightBtnWidth+endHalfOverMcWidth){
						vectorBtn[i].visible = true;
						farScale = (vectorBtn[i].x - endHalfOverMcWidth)/leftRightBtnWidth;
						vectorBtn[i].alpha = 1-farScale;
						vectorBtn[i].scaleX = vectorBtn[i].scaleY = vectorBtn[i].scaleX-farScale;
						vectorBtn[i].x = endHalfOverMcWidth+farScale*leftRightBtnWidth*.5;
					}else{
						vectorBtn[i].visible = false;
					}
				}else if( vectorBtn[i].x < -endHalfOverMcWidth ){
					if(vectorBtn[i].x >-leftRightBtnWidth-endHalfOverMcWidth){
						vectorBtn[i].visible = true;
						farScale = (-vectorBtn[i].x - endHalfOverMcWidth)/leftRightBtnWidth;
						vectorBtn[i].alpha = 1-farScale;
						vectorBtn[i].scaleX = vectorBtn[i].scaleY = vectorBtn[i].scaleX-farScale;
						vectorBtn[i].x = -endHalfOverMcWidth-farScale*leftRightBtnWidth*.5;
					}else{
						vectorBtn[i].visible = false;
					}
				}else{
					vectorBtn[i].visible = true;
					vectorBtn[i].alpha = 1;
				}
			}
		}
		
	}
}

class MoveVO
{
	public var velocity:Number=0;	
}