package EXIT.pixelbender.positionscale
{
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;

	public class PositionScaleFilter
	{
		
		[Embed("EXIT/pixelbender/positionscale/positionscale.pbj", mimeType="application/octet-stream")]
		private var positionscale:Class;
		
		private var _target			:DisplayObject;
		private var shader			:Shader;
		private var filter			:ShaderFilter;
		private var _x				:Number = 0;
		private var _y				:Number = 0;
		private var _scaleX			:Number = 1;
		private var _scaleY			:Number = 1;
		public function PositionScaleFilter( $target:DisplayObject )
		{
			_target = $target;
			
			shader = new Shader( new positionscale() as ByteArray );
			shader.data.scaleX.value = [1];
			filter = new ShaderFilter( shader );
			_target.filters = [filter];
		}
		
		public function set x( $value:Number ):void
		{
			_x = $value;
			shader.data.x.value = [_x];
			_target.filters = [filter];
		}
		
		public function set y( $value:Number ):void
		{
			_y = $value;
			shader.data.y.value = [_y];
			_target.filters = [filter];
		}
		
		public function set scaleX( $value:Number ):void
		{
			_scaleX = $value;
			shader.data.scaleX.value = [_scaleX];
			_target.filters = [filter];
		}
		
		public function set scaleY( $value:Number ):void
		{
			_scaleY = $value;
			shader.data.scaleY.value = [_scaleY];
			_target.filters = [filter];
		}
		
		public function get x():Number{ return _x; }
		public function get y():Number{ return _y; }
		public function get scaleX():Number{ return _scaleX; }
		public function get scaleY():Number{ return _scaleY; }
	}
}