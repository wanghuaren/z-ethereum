package com.bellaxu.map
{
	import com.bellaxu.def.MapDef;
	import com.bellaxu.def.ResPriorityDef;
	import com.bellaxu.res.MapResLoader;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;
	
	import scene.manager.SceneManager;

	/**
	 * 地图块 大小512 * 320
	 * <br/>自动加载
	 * <br/>加载完自动设置
	 * <br/>自动判断当前地图id，容错处理
	 * @author BellaXu
	 */
	internal class MapBlock extends Bitmap
	{
		public var tx:int; //x坐标
		public var ty:int; //y坐标
		public var url:String; //路径

		public function MapBlock()
		{
			
		}
		
		public function dispose():void
		{
			this.bitmapData = null;
			this.tx = 0;
			this.ty = 0;
			MapResLoader.getInstance().cancelRes(url,false);
			this.url = null;
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		private var version:String;
		
		public function load(mapId:int, i:int, j:int, drawNow:Boolean = false):void
		{
			//加载前要先清bitmapData，不然会一直用别的块直到加载完
			this.bitmapData = null;
			this.url = "Map/BigMap/" + mapId + "/" + i + "_" + j + ".jpg";
			//地图切片的版本依据地图数据的版本来
			if(drawNow && MapResLoader.getInstance().isLoaded(url))
			{
				onLoaded(url);
				return;
			}
			version = ResTool.getVer("Map/DataMap/" + mapId + ".txt");
			MapResLoader.getInstance().loadRes(url, onLoaded, version);
		}
		
		private function onLoaded(url:String):void
		{
			if(this.url != url)
				return;
			this.bitmapData = MapResLoader.getInstance().getMapBmd(url);
			if (this.bitmapData == null)
				MapResLoader.getInstance().loadRes(url, onLoaded, MathUtil.getRandomInt(0, 99999) + "");
		}
	}
}