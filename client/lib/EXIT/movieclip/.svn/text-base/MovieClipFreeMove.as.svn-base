package EXIT.movieclip 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author EXIT
	 */
	public class MovieClipFreeMove extends MovieClip
	{
		
		public var globalReferPoint:Point = new Point(0,0);
		public var localReferPoint:Point;
		public var useGlobalReferPoint:Boolean = false;
		public function MovieClipFreeMove()
		{			
			localReferPoint = new Point(this.width / 2, this.height / 2);
		}
		
		public override function get rotation():Number
		{
			return super.rotation;
		}
		public override function set rotation(_rotation:Number):void 
		{
			var oldGlobalReferPoint:Point = (useGlobalReferPoint)? globalReferPoint:this.localToGlobal(localReferPoint);
			var nowLocalReferPoint:Point = (useGlobalReferPoint)? this.globalToLocal(globalReferPoint):localReferPoint;

			super.rotation = _rotation;
			var newGlobalReferPoint:Point = this.localToGlobal(nowLocalReferPoint);
			this.x += oldGlobalReferPoint.x-newGlobalReferPoint.x;
			this.y += oldGlobalReferPoint.y-newGlobalReferPoint.y;
		}
	}

}