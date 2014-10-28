package com.engine.core.tile.square
{
	import com.engine.core.tile.TileConstant;
	
	import flash.geom.Point;
	import flash.net.registerClassAlias;

	/**
	 * 
	 * @author saiman
	 * 2012-5-31-下午2:14:00
	 */
	public class SquarePt
	{
		private var _x:int;
		private var _y:int;
		private static var size_w:Number=TileConstant.TILE_Width/2
		private static var size_h:Number=TileConstant.TILE_Height/2
		public function SquarePt(x:int=0,y:int=0)
		{
			flash.net.registerClassAlias('sai.save.core.tile.SquarePt',SquarePt);
			this.x=x;
			this.y=y;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get key():String
		{
			return this.x+'|'+this.y
		}
		public function get pixelsPoint():Point
		{
			var vx:Number= Number(Number(x*TileConstant.TILE_Width+size_w).toFixed(1));
			var vy:Number= Number(Number(y*TileConstant.TILE_Height+size_h).toFixed(1));
			return new Point(vx,vy)
		}
		public static  function pixelsDistance(pt1:SquarePt,pt2:SquarePt):Number
		{
			var x_1:Number=pt1.x*TileConstant.TILE_Width+size_w;
			var x_2:Number=pt2.x*TileConstant.TILE_Width+size_w;
			var y_1:Number=pt1.y*TileConstant.TILE_Height+size_h;
			var y_2:Number=pt2.y*TileConstant.TILE_Height+size_h;
			return Point.distance(new Point(x_1,y_1),new Point(x_2,y_2));
		}
		public function toString():String
		{
			return '[SquarePt('+this.x+','+this.y+')]'
		}
	}
}