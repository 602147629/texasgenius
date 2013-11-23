package EXIT.movieclip 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author EXIT
	 */
	public class SetFreeMove
	{
		
		public function SetFreeMove()
		{	
			trace("constructor");
		}
		public static function rotation(mc:DisplayObject, rotation:Number, referPoint:Point,useGlobalReferPoint:Boolean = false):void
		{
			var oldGlobalReferPoint:Point = (useGlobalReferPoint)? referPoint:mc.localToGlobal(referPoint);
			var nowLocalReferPoint:Point = (useGlobalReferPoint)? mc.globalToLocal(referPoint):referPoint;

			mc.rotation = rotation
			var newGlobalReferPoint:Point = mc.localToGlobal(nowLocalReferPoint);
			mc.x += oldGlobalReferPoint.x-newGlobalReferPoint.x;
			mc.y += oldGlobalReferPoint.y-newGlobalReferPoint.y;
		}
		public static function scale(mc:DisplayObject, value:Number, referPoint:Point,useGlobalReferPoint:Boolean = false):void
		{
			var oldGlobalReferPoint:Point = (useGlobalReferPoint)? referPoint:mc.localToGlobal(referPoint);
			var nowLocalReferPoint:Point = (useGlobalReferPoint)? mc.globalToLocal(referPoint):referPoint;
			
			mc.scaleX = mc.scaleY = value;
			var newGlobalReferPoint:Point = mc.localToGlobal(nowLocalReferPoint);
			mc.x += oldGlobalReferPoint.x-newGlobalReferPoint.x;
			mc.y += oldGlobalReferPoint.y-newGlobalReferPoint.y;
		}
	}

}