package EXIT.away3dcontroller.cameramovement
{
	import EXIT.away3dcontroller.Away3DController;
	
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class AbstractCameraMovement
	{
		public const TYPE			:String = "abstractcameramovement";
		private var view			:View3D;
		private var parent			:DisplayObjectContainer
		public function AbstractCameraMovement()
		{
		}
		
		public function connectController( view:View3D , parent:DisplayObjectContainer ):void
		{
			this.view = view;
			this.parent = parent;
			
			
			/*view.camera.position = new Vector3D( -viewDistance, viewDistance, viewDistance);
			view.camera.lookAt(new Vector3D(0, 0, 0));*/
		}
		
		public function dispose():void
		{
			
		}
	}
}