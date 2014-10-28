package com.engine.utils.gome
{
	import com.engine.core.tile.TileConstant;
	import com.engine.core.tile.square.SquarePt;
	
	import flash.geom.Point;

	/**
	 * 
	 * @author saiman
	 * 2012-5-31-下午3:46:14
	 */
	public class SquareUitls
	{
		public function SquareUitls()
		{
		}
		
		public static function xyToSquare(x:Number,y:Number):SquarePt
		{
			return new SquarePt(int(x/TileConstant.TILE_Width),int(y/TileConstant.TILE_Height))
		}
		
		public static function pixelsToSquare(point:Point):SquarePt
		{
			return new SquarePt(int(point.x/TileConstant.TILE_Width),int(point.y/TileConstant.TILE_Height))
		}
		
		public static function squareTopixels(point:SquarePt):Point
		{
			return point.pixelsPoint
		}
		
	}
}