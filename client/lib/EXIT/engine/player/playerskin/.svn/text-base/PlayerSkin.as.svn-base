package EXIT.engine.player.playerskin
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import EXIT.engine.player.playervdo.PlayerVdoEvent;
	
	public class PlayerSkin extends Sprite
	{
		public function PlayerSkin()
		{
			super();
		}
		
		
		protected var progress			:Number=0;
		protected var buffer			:Number=0;
		protected var startBuffer		:Number=0;
		
		/**
		 * 
		 * @param $value [from 0 to 1]
		 * 
		 */		
		public function updateBuffer( $start:Number , $value:Number ):void{
			startBuffer=$start;
			buffer=$value;	
		}
		
		/**
		 * 
		 * @param $time
		 * @param $duration
		 * 
		 */			
		public function updateProgress( $time:Number , $duration:Number ):void{
			progress=$time/$duration;
		}
		
			
		public function playSkin():void{}
		public function pauseSkin():void{}
		public function toggleFullscreen(event:MouseEvent=null):void{}
		public function togglePlayPause(event:MouseEvent=null):void{}
		public function showLoading( event:PlayerVdoEvent=null ):void{}
		public function hideLoading( event:PlayerVdoEvent=null ):void{}
		
		
		
		
		public override function get scaleX():Number{return 0;}
		public override function get scaleY():Number{return 0;}
		public override function set height( $value:Number ):void{}
		public override function set scaleX( $value:Number ):void{}
		public override function set scaleY( $value:Number ):void{}
	}
}