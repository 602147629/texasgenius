package net.area80.api.event
{

	import flash.events.Event;

	public class APIErrorEvent extends Event
	{
		public static const ERROR:String = "error";
		public var errorMessage:String;

		public function APIErrorEvent(errorMessage:String)
		{
			this.errorMessage = errorMessage;
			super(ERROR);
		}
	}
}
