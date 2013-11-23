package com.sleepydesign.utils
{

	public class VectorUtil
	{
		public static function toArray(vector:*):Array
		{
			const VECTOR_LENGTH:int = vector.length;
			const arr:Array = [];
			for (var i:int = 0; i < VECTOR_LENGTH; i++)
				arr[i] = vector[i];

			return arr;
		}

		public static function sortOn(vector:*, names:*, options:Object = null):Array
		{
			return toArray(vector).sortOn(names, options);
		}

		public static function getItemBy(vector:*, key:*, arg:String = "id"):*
		{
			for each (var _item:* in vector)
				if (_item[arg] == key)
					return _item;

			return null;
		}

		public static function getItemByID(vector:*, id:String):*
		{
			return getItemBy(vector, id, "id");
		}

		public static function removeItemAt(vector:*, index:int):*
		{
			if (!vector)
				return null;

			if (index == -1)
				return index;

			const fixed:Boolean = vector.fixed;

			vector.fixed = false;

			const item:* = vector[index];

			vector.splice(index, 1);

			vector.fixed = fixed;

			return item;
		}

		public static function removeItem(vector:*, item:*):*
		{
			return removeItemAt(vector, vector.indexOf(item));
		}

		public static function removeItemByID(vector:*, id:String):*
		{
			return removeItemBy(vector, id);
		}

		public static function removeItemBy(vector:*, key:*, arg:String = "id"):*
		{
			if (!vector)
				return null;

			return removeItemAt(vector, vector.indexOf(getItemBy(vector, key, arg)));
		}
	}
}
