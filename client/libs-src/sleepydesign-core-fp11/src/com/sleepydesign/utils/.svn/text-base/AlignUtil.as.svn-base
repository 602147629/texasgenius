/*
	CASA Lib for ActionScript 3.0
	Copyright (c) 2011, Aaron Clinger & Contributors of CASA Lib
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

	- Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.

	- Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.

	- Neither the name of the CASA Lib nor the names of its contributors
	  may be used to endorse or promote products derived from this software
	  without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/
package com.sleepydesign.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
		Provides utility functions for aligning.

		@author Aaron Clinger
		@author Jon Adams
		@version 05/19/11
	*/
	public class AlignUtil
	{
		public static const BOTTOM:String = 'bottom';
		public static const BOTTOM_CENTER:String = 'bottomCenter';
		public static const BOTTOM_LEFT:String = 'bottomLeft';
		public static const BOTTOM_RIGHT:String = 'bottomRight';
		public static const CENTER:String = 'center';
		public static const LEFT:String = 'left';
		public static const MIDDLE:String = 'middle';
		public static const MIDDLE_CENTER:String = 'middleCenter';
		public static const MIDDLE_LEFT:String = 'middleLeft';
		public static const MIDDLE_RIGHT:String = 'middleRight';
		public static const RIGHT:String = 'right';
		public static const TOP:String = 'top';
		public static const TOP_CENTER:String = 'topCenter';
		public static const TOP_LEFT:String = 'topLeft';
		public static const TOP_RIGHT:String = 'topRight';

		/**
		 * Will align to stage rect
		 *
		 * @param alignment
		 * @param displayObject
		 * @param snapToPixel
		 * @param outside
		 * @return
		 *
		 */
		public static function alignToStage(alignment:String, displayObject:DisplayObject, snapToPixel:Boolean = true, outside:Boolean = false):DisplayObject
		{
			alignToRect(alignment, displayObject, new Rectangle(0, 0, displayObject.stage.stageWidth, displayObject.stage.stageHeight), snapToPixel, outside);

			return displayObject;
		}

		/**
		 * Will align to rect
		 *
		 * @param alignment
		 * @param displayObject
		 * @param rect
		 * @param snapToPixel
		 * @param outside
		 * @return
		 *
		 */
		public static function alignToRect(alignment:String, displayObject:DisplayObject, rect:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):DisplayObject
		{
			align(alignment, displayObject, rect, snapToPixel, outside, null);

			return displayObject;
		}

		/**
		 * Will add padding against rect
		 *
		 * @param padding top, right, bottom, and left as an Array eg. [0, 0, 0, 0]
		 * @param displayObject
		 * @param bounds: The area in which to pad the <code>DisplayObject</code>.
		 * @return displayObject
		 *
		 */
		public static function padToRect(padding:Array, displayObject:DisplayObject, bounds:Rectangle):DisplayObject
		{
			// silent fail
			if (!padding || padding.length == 0)
				return displayObject;

			const relPosition:Rectangle = displayObject.getBounds(displayObject.parent);

			// all same
			if (padding.length == 1)
				padding.push(padding[0], padding[0], padding[0]);

			//top
			if (!isNaN(padding[0]) && relPosition.top <= bounds.top)
				displayObject.y = bounds.y + padding[0];

			//right
			if (!isNaN(padding[1]) && relPosition.right >= bounds.right)
				displayObject.x = bounds.right - displayObject.width - padding[1];

			//bottom
			if (!isNaN(padding[2]) && relPosition.bottom >= bounds.bottom)
				displayObject.y = bounds.bottom - displayObject.height - padding[2];

			//left
			if (!isNaN(padding[3]) && relPosition.left <= bounds.left)
				displayObject.x = bounds.left + padding[3];

			return displayObject;
		}

		/**
			Aligns a <code>DisplayObject</code> to the bounding <code>Rectangle</code> acording to the defined alignment.

			@param alignment: The alignment type/position.
			@param displayObject: The <code>DisplayObject</code> to align.
			@param bounds: The area in which to align the <code>DisplayObject</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>DisplayObject</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>DisplayObject</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
			@param targetCoordinateSpace: The display object that defines the coordinate system to use. Specify if the <code>displayObject</code> is not in the same scope as the desired coordinate space, or <code>null</code> to use the <code>displayObject</code>'s coordinate space.
		*/
		public static function align(alignment:String, displayObject:DisplayObject, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false, targetCoordinateSpace:DisplayObject = null):void
		{
			const offsetPosition:Point = getOffsetPosition(displayObject);

			switch (alignment)
			{
				case AlignUtil.TOP:
				case AlignUtil.MIDDLE:
				case AlignUtil.BOTTOM:
					break;
				default:
					displayObject.x = offsetPosition.x;
			}

			switch (alignment)
			{
				case AlignUtil.LEFT:
				case AlignUtil.CENTER:
				case AlignUtil.RIGHT:
					break;
				default:
					displayObject.y = offsetPosition.y;
			}

			const alignPosition:Point = AlignUtil._getPosition(alignment, displayObject.width, displayObject.height, bounds, outside);
			const relPosition:Rectangle = displayObject.getBounds((targetCoordinateSpace == null) ? displayObject : targetCoordinateSpace);

			switch (alignment)
			{
				case AlignUtil.TOP:
				case AlignUtil.MIDDLE:
				case AlignUtil.BOTTOM:
					break;
				default:
					displayObject.x += alignPosition.x - relPosition.x;

					if (snapToPixel)
						displayObject.x = Math.round(displayObject.x);
			}

			switch (alignment)
			{
				case AlignUtil.LEFT:
				case AlignUtil.CENTER:
				case AlignUtil.RIGHT:
					break;
				default:
					displayObject.y += alignPosition.y - relPosition.y;

					if (snapToPixel)
						displayObject.y = Math.round(displayObject.y);
			}
		}

		/**
			Aligns a <code>Rectangle</code> to another <code>Rectangle</code>.

			@param align: The alignment type/position.
			@param rectangle: The <code>Rectangle</code> to align.
			@param bounds: The area in which to align the <code>Rectangle</code>.
			@param snapToPixel: Force the position to whole pixels <code>true</code>, or to let the <code>Rectangle</code> be positioned on sub-pixels <code>false</code>.
			@param outside: Align the <code>Rectangle</code> to the outside of the bounds <code>true</code>, or the inside <code>false</code>.
			@return A new aligned <code>Rectangle</code>.
		*/
		public static function alignRectangle(alignment:String, rectangle:Rectangle, bounds:Rectangle, snapToPixel:Boolean = true, outside:Boolean = false):Rectangle
		{
			const alignedRectangle:Rectangle = rectangle.clone();

			alignedRectangle.offsetPoint(AlignUtil._getPosition(alignment, rectangle.width, rectangle.height, bounds, outside));

			if (snapToPixel)
			{
				alignedRectangle.x = Math.round(alignedRectangle.x);
				alignedRectangle.y = Math.round(alignedRectangle.y);
			}

			return alignedRectangle;
		}

		/**
			Aligns a <code>DisplayObject</code> to the nearest Pixel.

			@param displayObject: The <code>DisplayObject</code> to align.
		*/
		public static function alignToPixel(displayObject:DisplayObject):void
		{
			displayObject.x = Math.round(displayObject.x);
			displayObject.y = Math.round(displayObject.y);
		}

		protected static function _getPosition(alignment:String, targetWidth:uint, targetHeight:uint, bounds:Rectangle, outside:Boolean):Point
		{
			const position:Point = new Point();

			switch (alignment)
			{
				case AlignUtil.BOTTOM_LEFT:
				case AlignUtil.LEFT:
				case AlignUtil.MIDDLE_LEFT:
				case AlignUtil.TOP_LEFT:
					position.x = outside ? bounds.x - targetWidth : bounds.x;
					break;
				case AlignUtil.BOTTOM_CENTER:
				case AlignUtil.CENTER:
				case AlignUtil.MIDDLE_CENTER:
				case AlignUtil.TOP_CENTER:
					position.x = (bounds.width - targetWidth) * 0.5 + bounds.x;
					break;
				case AlignUtil.BOTTOM_RIGHT:
				case AlignUtil.MIDDLE_RIGHT:
				case AlignUtil.RIGHT:
				case AlignUtil.TOP_RIGHT:
					position.x = outside ? bounds.right : bounds.right - targetWidth;
					break;
			}

			switch (alignment)
			{
				case AlignUtil.TOP:
				case AlignUtil.TOP_CENTER:
				case AlignUtil.TOP_LEFT:
				case AlignUtil.TOP_RIGHT:
					position.y = outside ? bounds.y - targetHeight : bounds.y;
					break;
				case AlignUtil.MIDDLE:
				case AlignUtil.MIDDLE_CENTER:
				case AlignUtil.MIDDLE_LEFT:
				case AlignUtil.MIDDLE_RIGHT:
					position.y = (bounds.height - targetHeight) * 0.5 + bounds.y;
					break;
				case AlignUtil.BOTTOM:
				case AlignUtil.BOTTOM_CENTER:
				case AlignUtil.BOTTOM_LEFT:
				case AlignUtil.BOTTOM_RIGHT:
					position.y = outside ? bounds.bottom : bounds.bottom - targetHeight;
					break;
			}

			return position;
		}

		/**
		 Returns the X and Y offset to the top left corner of the <code>DisplayObject</code>. The offset can be used to position <code>DisplayObject</code>s whose alignment point is not at 0, 0 and/or is scaled.

		 @param displayObject: The <code>DisplayObject</code> to align.
		 @return The X and Y offset to the top left corner of the <code>DisplayObject</code>.
		 @example
		 <code>
		 var box:CasaSprite = new CasaSprite();
		 box.scaleX         = -2;
		 box.scaleY         = 1.5;
		 box.graphics.beginFill(0xFF00FF);
		 box.graphics.drawRect(-20, 100, 50, 50);
		 box.graphics.endFill();

		 const offset:Point = DisplayObjectUtil.getOffsetPosition(box);

		 trace(offset)

		 box.x = 10 + offset.x;
		 box.y = 10 + offset.y;

		 this.addChild(box);
		 </code>
		 */
		private static function getOffsetPosition(displayObject:DisplayObject):Point
		{
			const bounds:Rectangle = displayObject.getBounds(displayObject);
			const offset:Point = new Point();

			offset.x = (displayObject.scaleX > 0) ? bounds.left * displayObject.scaleX * -1 : bounds.right * displayObject.scaleX * -1;
			offset.y = (displayObject.scaleY > 0) ? bounds.top * displayObject.scaleY * -1 : bounds.bottom * displayObject.scaleY * -1;

			return offset;
		}
	}
}
