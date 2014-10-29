package com.bellaxu.util 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * 关于文本的一些公用方法
	 * @author BellaXu
	 */
	public final class TextUtil 
	{
		/**
		 * 设置文本颜色，对其方式等
		 */
		public static function  setTextColor(text:TextField, color:uint = 0xffffff, align:String = "center"):void 
		{
			text.textColor = color;
			text.autoSize = align;
		}
	}
}
