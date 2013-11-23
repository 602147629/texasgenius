package EXIT.service
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;

	public class snapPosition
	{
		public function snapPosition()
		{
		}
		public static function snapAll( $object : DisplayObject ):void
		{
//			trace('______'+ ( $object is DisplayObjectContainer ));
			snapParent( $object );
			snapChildren( $object );
		}
		/**
		 *Snap all my children (not snap me)
		 * @param $object
		 * 
		 */	
		public static function snapChildren( $object : DisplayObject ):void
		{
			snapInheritChildren( $object );
			function snapInheritChildren( tempObject:DisplayObject ):void
			{
				if( tempObject is DisplayObjectContainer ){
					var tempDisplayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(tempObject);
					for(var i:uint = 0 ; i <= tempDisplayObjectContainer.numChildren-1 ; i++){
						var child:DisplayObject = tempDisplayObjectContainer.getChildAt(i);
//						trace($parentString+child);
						if(child is InteractiveObject) {
							snap(child);
						}
						snapInheritChildren(child );
					}
					
				}
			}
		}
		 
		/**
		 *Snap me to my parent until stage (snap me to )
		 * @param $object
		 * 
		 */		
		public static function snapParent( $object : DisplayObject ):void
		{
			if($object.stage) snapInheritParent();
			else $object.addEventListener(Event.ADDED_TO_STAGE,snapInheritParent);
				
			function snapInheritParent( event:Event=null ):void
			{
				if(event)event.currentTarget.removeEventListener(Event.ADDED_TO_STAGE,snapInheritParent);
				var step:String ='|_';
				var tempObject:DisplayObject = $object;
//				trace('START SET ROUND XY .....'+tempObject);
				while(tempObject && !(tempObject is Stage)){
					snap(tempObject);
//					trace(step+tempObject);
					tempObject = tempObject.parent;
					step += '|_ ';
				}
//				trace('.END SET ROUND XY .....parent='+tempObject);
			}
		}
		
		public static function snap( $object : DisplayObject ):void
		{
				$object.x = Math.round( $object.x );
				$object.y = Math.round( $object.y );
		}
		
	}
}