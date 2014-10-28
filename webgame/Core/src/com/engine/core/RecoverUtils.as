package com.engine.core
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 	为了减少某些常用类实例的频繁创建。而提供的一些单次性使用的单例实例
	 *  回收用例每次使用属性都会重设，改类对象不能用于属性赋值，只能用于一次性的临时计算 
	 * @author saiman
	 * @since asswc.com;
	 * @see http://www.asswc.com
	 *
	 * @example 示例说明:<listing version="3.0">code example here.</listing>
	 *
	 **/
	
	public class RecoverUtils
	{
		private static var _mat_:Matrix=new Matrix
		private static var _point_:Point=new Point;
		private static var _rect_:Rectangle=new Rectangle
		
		/**
		 *   Matrix回收用例，回收用例每次使用属性都会重设，改类对象不能用于属性赋值，只能用于一次性的临时计算 
		 * @return 
		 * 
		 */		
		public static function get matrix():Matrix
		{
			_mat_.identity()
			return _mat_;
		}
		/**
		 *   Point回收用例，回收用例每次使用属性都会重设，改类对象不能用于属性赋值，只能用于一次性的临时计算  
		 * @return 
		 * 
		 */		
		public static function get point():Point
		{
			_point_.x=0;
			_point_.y=0
			return _point_;
		}
		/**
		 *   Rectangle回收用例，回收用例每次使用属性都会重设，改类对象不能用于属性赋值，只能用于一次性的临时计算  
		 * @return 
		 * 
		 */		
		public static function get rect():Rectangle
		{
			_rect_.isEmpty();
			return _rect_;
		}
		
		
		
	}
}