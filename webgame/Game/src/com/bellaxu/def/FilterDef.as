package com.bellaxu.def
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;

	/**
	 * 公用滤镜
	 * @author BellaXu
	 */
	public class FilterDef
	{
		/** 发光  **/
		public static const GLOW_VIEW:GlowFilter = new GlowFilter(0xFF9900, 1, 6, 6, 2, BitmapFilterQuality.LOW, false, false);
		public static const GLOW_VIEW_2:GlowFilter = new GlowFilter(0x000000, 1, 3, 3, 3, BitmapFilterQuality.LOW, false, false);
		public static const GLOW_VIEW_3:GlowFilter = new GlowFilter(0xffffff, 1, 3, 3, 3, BitmapFilterQuality.LOW, false, false);
		
		public static const GLOW_NPC:GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 4, BitmapFilterQuality.LOW, false, false);
		public static const GLOW_PLAYER:GlowFilter = new GlowFilter(0x6ff00, 1, 2, 2, 4, BitmapFilterQuality.LOW, false, false);
		public static const GLOW_MONSTER:GlowFilter = new GlowFilter(0xff1800, 1, 2, 2, 4, BitmapFilterQuality.LOW, false, false);
		
		/**
		 * 获取指定颜色的矩阵滤镜
		 * @color 自定义颜色
		 */
		public static function getColorMatrixFilterByColor(color:uint):ColorMatrixFilter
		{
			var r:uint = color >> 16 & 0xFF;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			var matrix:Array = [r/255, 0.59, 0.11, 0, 0, 
				g/255, 0.59, 0.11, 0, 0, 
				b/255, 0.59, 0.11, 0, 0, 
				0, 0, 0, 1, 0];
			var cmf:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return cmf;
		}
		
	}
}