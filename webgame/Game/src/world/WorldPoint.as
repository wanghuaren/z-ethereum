package world
{
	import com.engine.core.tile.TileConstant;

	import flash.geom.Point;

	import scene.utils.MapData;

	public class WorldPoint extends Point
	{
		private var _mapx:int;
		private var _mapy:int;

		/**
		 * dx = display x (显示坐标);
		 *
		 */
		public function WorldPoint(dx:Number, dy:Number, mapx:int, mapy:int)
		{
			super(dx, dy);

			this._mapx=mapx;
			this._mapy=mapy;
		}

		public function get mapx():int
		{
			return _mapx;
		}

		public function set mapx(value:int):void
		{
			_mapx=value;
		}

		public function get mapy():int
		{
			return _mapy;
		}

		public function set mapy(value:int):void
		{
			_mapy=value;
		}
		private static var _instance:WorldPoint;

		public static function getInstance():WorldPoint
		{
			if (_instance == null)
			{
				_instance=new WorldPoint(0, 0, 0, 0);
			}
			return _instance;
		}
		public static var vectorPoolItems:Vector.<WorldPoint>=new Vector.<WorldPoint>();

		public function getItem(dx:Number, dy:Number, mapx:int, mapy:int):WorldPoint
		{
			var currItem:WorldPoint;
			if (WorldPoint.vectorPoolItems.length < 1)
			{
				for (var i:int=0; i < 200; i++)
				{
					WorldPoint.vectorPoolItems.push(new WorldPoint(0, 0, 0, 0));
				}
			}
			currItem=WorldPoint.vectorPoolItems.pop();
			var a:int=TileConstant.TILE_Width;
			var b:int=TileConstant.TILE_Height;
			currItem.x=dx;
			currItem.y=dy;
			currItem._mapx=mapx;
			currItem._mapy=mapy;
			//			currItem._mapx=int(mapx/TileConstant.TILE_Width)*TileConstant.TILE_Width+TileConstant.TILE_Width*0.5;
			//			currItem._mapy=int(mapy/TileConstant.TILE_Height)*TileConstant.TILE_Height+TileConstant.TILE_Height*0.5;


			return currItem;
		}

		/**
		 * 得到地图格子坐标 andy 2014-08-07
		 * @param dx
		 * @param dy
		 * @param mapx
		 * @param mapy
		 * @return
		 *
		 */
		public function getItemGrid(dx:Number, dy:Number, mapx:int, mapy:int):WorldPoint
		{
			var currItem:WorldPoint;
			if (WorldPoint.vectorPoolItems.length < 1)
			{
				for (var i:int=0; i < 200; i++)
				{
					WorldPoint.vectorPoolItems.push(new WorldPoint(0, 0, 0, 0));
				}
			}
			currItem=WorldPoint.vectorPoolItems.pop();
			currItem.x=dx / MapData.TW;
			currItem.y=dy / MapData.TH;
			currItem._mapx=mapx / MapData.TW;
			currItem._mapy=mapy / MapData.TH;
			return currItem;
		}
	}
}
