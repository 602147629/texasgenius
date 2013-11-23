package net.area80.facebook.graph.vo
{

	public class FBError extends FBResponse
	{
		public var message:String = "";
		public var type:String = "";
		public var code:String = "";

		public function FBError(message:String, type:String, code:String)
		{
			this.message = message;
			this.type = type;
			this.code = code;
		}

		public function clone():FBError
		{
			return new FBError(this.message, this.type, this.code);
		}
	}
}
