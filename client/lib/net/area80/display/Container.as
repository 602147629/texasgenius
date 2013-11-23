package net.area80.display
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import net.area80.utils.LoaderUtils;
	
	/**
	 * Container which has clear method to remove all of its children and stop their working to be ready for garbage collector. 
	 * @author wissarut
	 * 
	 */
	public class Container extends Sprite
	{
		public function Container()
		{
			super();
		}
		
		/**
		 * Remove all its children, unload and stop if they are Loader or Movieclip 
		 * 
		 */
		public function clear():void
		{
			if (this.numChildren > 0)
			{
				while (this.numChildren>0)
				{
					var child:DisplayObject = getChildAt(0) as DisplayObject;
					if (child)
					{
						if (child is Loader)
						{
							LoaderUtils.clearLoader(Loader(child));
						}
						else if (child is MovieClip)
						{
							MovieClip(child).stop();
							try
							{
								MovieClip(child).soundTransform = null;
							}
							catch (e:Error)
							{
							}
						}
						removeChild(child);
					}
					
				}
			}
		}
	}
}