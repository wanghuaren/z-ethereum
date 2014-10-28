package com.engine.utils.gome
{
	import flash.geom.Point;
	/**
	 * 线性扇形计算工具类 
	 * @author saiman
	 * 
	 */
	public class LinearAndFan
	{
		/**
		 * 线性技能 
		 * @param startPoint
		 * @param endPoint
		 * @param interval
		 * @return 
		 * 
		 */		
		public static function lineAttck(startPoint:Point,endPoint:Point,interval:int=80):Array
		{
			if(!startPoint||!endPoint)return [];
			var x:Number=startPoint.x;
			var y:Number=startPoint.y;
			var radius:Number=Point.distance(startPoint,endPoint);
		
			var p:Point;
			var arr:Array=[]
			var num:int=radius/interval
			for(var i:int=0;i<num;i++)
			{
				p=Point.interpolate(startPoint,endPoint,(1-i/num))
				arr.push(p)
			}
			return arr;
		}
		/**
		 *  点 pt1与点pt2延长线外一定距离的点
		 * @param pt1
		 * @param pt2
		 * @param dis
		 * @return 
		 * 
		 */		
		public static function pointBetweenPoint(pt1:Point,pt2:Point,dis:int):Point
		{
			if(!pt1||!pt2)return null;
			var _dis:Number=Point.distance(pt1,pt2)
			var x:Number=pt2.x+dis/_dis*(pt2.x-pt1.x);
			var y:Number=pt2.y+dis/_dis*(pt2.y-pt1.y);
			return new Point(x,y)
		}
		/**
		 * 扇面线性 
		 * @param startPoint
		 * @param endPoint
		 * @param area
		 * @param n
		 * @param minRadius
		 * @return 
		 * 
		 */		
		public static function lineSectorAttack(startPoint:Point,endPoint:Point,area:Number,n:int=3,minRadius:int=200):Array
		{
			if(!startPoint||!endPoint)return [];
			var array:Array=sectorAttack(startPoint,endPoint,area,n,minRadius)
			var arr:Array=[]
			for(var i:int=0;i<array.length;i++)
			{
				arr[i]=lineAttck(startPoint,array[i])
			}
			return arr
		}
		/**
		 *  
		 * @param x 圆心 x
		 * @param y 圆心 y
		 * @param radius 半径
		 * @param area 扇形范围
		 * @param startRotation 开始角度
		 * @param n 均分数目
		 * @return 
		 * 
		 */		
		public static function sectorAttack(startPoint:Point,endPoint:Point,area:Number,n:int=3,minRadius:int=200):Array
		{
			var size:Number=area
			if(size<=0)return [];
			if(size > 360) size = 360;
			
			size = Math.PI/180 * size;
		
			
			
			var x:Number=startPoint.x;
			var y:Number=startPoint.y;
			var radius:Number=Point.distance(startPoint,endPoint);
			
			//指向的弧度
			var dx:Number = endPoint.x - startPoint.x;
			var dy:Number = endPoint.y - startPoint.y;
			var anglex:Number = Math.atan2(dy, dx);
			var rotation:int=anglex* 180 / Math.PI;
			rotation-=area/2;
			
			var angleN:Number = size/n;
			//绘制二次贝塞尔曲线的外切半径
			var tangentRadius:Number = radius/Math.cos(angleN/2);
			//转换为弧度
			var angle:Number=rotation* Math.PI / 180;
			
			
			if(minRadius!=-1&&radius<minRadius)
			{
				radius=minRadius
				var _x:Number = x + Math.cos(angle) * radius;
				var _y:Number = y + Math.sin(angle) * radius;
				endPoint.x=_x;
				endPoint.y=_y;
				
				dx= endPoint.x - startPoint.x;
				dy = endPoint.y - startPoint.y;
				anglex = Math.atan2(dy, dx);
				rotation=anglex* 180 / Math.PI;
				rotation-=area/2;
				
				angleN = size/n;
				//绘制二次贝塞尔曲线的外切半径
				tangentRadius = radius/Math.cos(angleN/2);
				//转换为弧度
				angle=rotation* Math.PI / 180;
				
			}
			
			var cx:Number;
			var cy:Number;
			var ax:Number;
			var ay:Number;
			
			//开始角度再圆上的位置
			var startX:Number = x + Math.cos(angle) * radius;
			var startY:Number = y + Math.sin(angle) * radius;
			var arr:Array=[]
			arr.push(new Point(startX,startY))
			
		
			for (var i:Number = 0; i < n; i++) 
			{
				
				//绘制2次贝塞尔曲线，
				angle += angleN;
				//求出开始点与将要绘制点的角平分线与将要绘制点的交点
				cx = x + Math.cos(angle-(angleN/2))*(tangentRadius);
				cy = y + Math.sin(angle-(angleN/2))*(tangentRadius);
				//僬侥绘制点在圆上的位置
				ax = x + Math.cos(angle) * radius;
				ay = y + Math.sin(angle) * radius;
				var p:Point=new Point(ax,ay)
				arr.push(p)
			}
			return arr
			
		}
	}
}