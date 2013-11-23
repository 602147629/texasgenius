package net.area80.facebook.graph
{

	import flash.events.Event;
	import net.area80.facebook.graph.vo.FBResponse;

	public class FBGraphEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public var method:String;
		public var response:FBResponse;

		public function FBGraphEvent(type:String, response:FBResponse, method:String)
		{
			this.response = response;
			this.method = method;
			super(type, false, false);
		}
	}
}
