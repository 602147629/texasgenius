package EXIT.engine.player.playervdo
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.media.Video;

	public interface IPlayerVdo extends IEventDispatcher
	{
		function play():void;
		function pause():void;
		function connect():void;
		function disconnect():void;
		
		function seek( $value:Number ):void;
		function get time():Number;
		function get duration():Number;
		
		function get startBytes():Number;
		function get bytesLoaded():Number;
		function get vdoSprite():Sprite;
		function get vdoWidth():Number;
		function get vdoHeight():Number;
		function set volumn( $value:Number ):void;
		
		function get width():Number;
		function get height():Number;
		function set width( $value:Number ):void;
		function set height( $value:Number ):void;
		function setSize( $width:Number , $height:Number ):void;
			
		function get showAll():Boolean;
		function set showAll( $value:Boolean ):void;
	}
}