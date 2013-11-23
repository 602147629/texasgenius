package com.sleepydesign.components.items
{
	import com.sleepydesign.core.IIDObject;

	public class SDItemData implements IIDObject
	{
		private var _id:String;

		public function get id():String
		{
			return _id;
		}

		public function SDItemData(id:String)
		{
			_id = id;
		}
	}
}
