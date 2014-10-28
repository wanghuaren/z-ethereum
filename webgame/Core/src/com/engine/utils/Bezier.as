package com.engine.utils
{
	import flash.geom.Point;
	/**
	 * 贝塞尔曲线 
	 * @author saiman
	 * 
	 */
	public class Bezier
	{
		public function Bezier()
		{
		}
		
		/**
		 * 3次贝塞尔曲线 
		 * @param p1
		 * @param p2
		 * @param c1
		 * @param c2
		 * @param num
		 * @return 
		 * 
		 */		
		public static function drawBezier3(p1:Point,p2:Point,c1:Point,c2:Point,num:int=10):Array
		{
			var n:Number=1/num
			var array:Array=[]
			for( var t:Number=0;t<=1;t+=n)
			{
				var t_:Number=1-t;
				var vx:Number =pow(t_,3)*p1.x + 3*c1.x*t*pow(t_,2)+3*c2.x*pow(t,2)*t_+p2.x*pow(t,3);
				var vy:Number =pow(t_,3)*p1.y + 3*c1.y*t*pow(t_,2)+3*c2.y*pow(t,2)*t_+p2.y*pow(t,3);
				array.push(new Point(vx,vy))
			}
			return array
		}
		/**
		 * 2次贝塞尔曲线 
		 * @param p1
		 * @param p2
		 * @param c
		 * @param num
		 * @return 
		 * 
		 */		
		public static function drawBezier(p1:Point,p2:Point,c:Point,num:int=40):Array
		{
			var n:Number=1/num
			var array:Array=[]
			for( var t:Number=0;t<=1;t+=n)
			{
				var t_:Number=1-t;
				var vx:Number =Math.pow((1-t),2)*p1.x+2*t*(1-t)*c.x+Math.pow(t,2)*p2.x;
				var vy:Number =Math.pow((1-t),2)*p1.y+2*t*(1-t)*c.y+Math.pow(t,2)*p2.y;
				array.push(new Point(vx,vy))
			}
			return array
		}
		
		public static function pow(x:Number,y:Number):Number
		{
			return Math.pow(x,y)
		}
	}
}