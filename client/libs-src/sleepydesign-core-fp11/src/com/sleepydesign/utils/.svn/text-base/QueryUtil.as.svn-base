package com.sleepydesign.utils
{

	public class QueryUtil
	{
		public static function select(vector:*, key:*, arg:String = "id"):*
		{
			var results:Array = [];

			for each (var _item:* in vector)
				if (_item[arg] == key)
					results.push(_item);

			return results;
		}
	}
}
