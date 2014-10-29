package com.bellaxu.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.filters.ColorMatrixFilter;

	/**
	 * 显示对方常用方法
	 */
	public class DisplayUtil
	{
		public static var disabledFilter:ColorMatrixFilter =
			new ColorMatrixFilter([0.5, 0.5, 0.0820, 0, 0, 0.5, 0.5, 0.082, 0, 0, 0.5, 0.5, 0.082,
				0, 0, 0, 0, 0, 1, 0]);

		/**
		 * Remove all children
		 */
		public static function clearChildren(dis:DisplayObjectContainer, begin:int = 0) : void
		{
			while(dis.numChildren > begin)
			{
				dis.removeChildAt(begin);
			}
		}
		
		public static function getDisplayObjName(dis:DisplayObjectContainer):String
		{
			var str:String = dis.toString();
			var bi:int = str.lastIndexOf(" ");
			var ei:int = str.lastIndexOf("]");
			return str.substring(bi + 1, ei);
		}
		
		public static function listChildren(dis:DisplayObjectContainer, cell:int = 1, iw:int = 0, ih:int = 0, bx:int = 0, by:int = 0, ix:int = 0, iy:int = 0):void
		{
			if (!dis)
				return;
			if (dis.numChildren == 0)
				return;
			if (iw == 0)
				iw = dis.getChildAt(0).width;
			if (ih == 0)
				ih = dis.getChildAt(0).height;
			var len:int = dis.numChildren;
			var row:int = 0;
			var col:int = 0;
			var child:Object = null;
			for (var m:int = 0; m < len; m++)
			{
				child = dis.getChildAt(m);
				col = m % cell;
				row = m / cell;
				child.x = bx + col * (iw + ix);
				child.y = by + row * (ih + iy);
			}
		}
		
		/**
		 * 设置Enabled
		 * @param dis : DisplayObject 对象
		 * @param enabled : Boolean enabled/disabled
		 */
		public static function setEnabled(dis:DisplayObject, enabled:Boolean) : void
		{
			if(dis is InteractiveObject)
			{
				InteractiveObject(dis).mouseEnabled = enabled;
			}
			if(enabled == false)
			{
				dis.filters = [disabledFilter];
			}
			else
			{
				dis.filters = [];
			}
		}
	}
}