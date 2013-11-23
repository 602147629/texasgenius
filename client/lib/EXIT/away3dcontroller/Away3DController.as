package EXIT.away3dcontroller
{
	import EXIT.away3dcontroller.cameramovement.AbstractCameraMovement;
	
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.primitives.WireframeGrid;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Vector3D;

	public class Away3DController
	{
		public var view							:View3D;
		private var parent						:DisplayObjectContainer;
		private var _cameraMovement				:AbstractCameraMovement;
		
		// debug
		private var _grid						:WireframeGrid;
		private var _state						:AwayStats;
		private var _isDebug					:Boolean=false;
		
		public function Away3DController( parent:DisplayObjectContainer )
		{
			this.parent = parent;
			
			
			view = new View3D();
			view.backgroundColor = 0x333333;
			view.antiAlias = 4;
			view.camera.lens.near = 0.2;
			parent.addChild(view);
			
			(view.camera.lens as PerspectiveLens).fieldOfView = 60;
		}
		
		public function set cameraMovement(_cameraMovement:AbstractCameraMovement):void
		{
			this._cameraMovement=_cameraMovement;
			this._cameraMovement.connectController(view,parent);
		}
		
		
		
		
		/**
		 * 
		 * @param _isShowGrid
		 * 
		 */		
		public function set isDebug(_isDebug:Boolean):void
		{
			if(_isDebug){
				if(!this._isDebug){
					_grid = new WireframeGrid(20, 500, 2, 0x666666);
					view.scene.addChild(_grid);
					
					_state = new AwayStats(view) 
					parent.addChild(_state);
				}
			}else{
				if(this._isDebug){
					view.scene.removeChild(_grid);
					parent.removeChild(_state);
				}
			}
			this._isDebug = _isDebug;
		}
		public function get isDebug():Boolean
		{
			return _isDebug;
		}
	}
}