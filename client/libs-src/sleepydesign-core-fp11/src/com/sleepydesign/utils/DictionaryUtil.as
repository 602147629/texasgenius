package com.sleepydesign.utils
{
	import flash.utils.Dictionary;
	
	public class DictionaryUtil
	{
		public static function removeItemBy(items:Dictionary, item:*, arg:String = "id"):Dictionary
		{
			if (!items)
				return null;
			
			var _items:Dictionary = new Dictionary();
			for (var _item:* in items)
				if (items[_item][arg] != item)
					_items[_item] = items[_item];
			
			return _items;
		}
		
		public static function removeItem(items:Dictionary, item:*, key:* = null):Dictionary
		{
			var _items:Dictionary;
			
			if (key)
			{
				_items = removeItemBy(items, key);
			}
			else if (items[item])
			{
				_items = new Dictionary()
				for (var _item:* in items)
					if (_item != item)
						_items[_item] = items[_item];
				
				items = _items;
			}
			
			return _items;
		}
	}
}
