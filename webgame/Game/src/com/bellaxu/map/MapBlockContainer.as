package com.bellaxu.map
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.def.MapDef;
	import com.bellaxu.map.MapBlockPool;
	import com.bellaxu.mgr.TimerMgr;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.DisplayUtil;
	import com.bellaxu.util.MathUtil;
	
	import common.config.xmlres.XmlManager;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netc.Data;
	
	import scene.action.Action;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import ui.frame.ImageUtils;

	/**
	 * 地图类
	 * @author BellaXu
	 */
	public class MapBlockContainer extends Sprite
	{
		private static var _instance:MapBlockContainer = null;
		public static var H_BLOCK_NUM:int = 1;
		public static var V_BLOCK_NUM:int = 1;
		
		private var mapId:int;
		private var resId:int;
		private var maxX:int;
		private var maxY:int;
		private var oldTileX:int = -1;
		private var oldTileY:int = -1;
		private var curBlockDic:Dictionary = new Dictionary();

		public function MapBlockContainer()
		{
			MapBlockPool.init();
			LayerDef.gridLayer.addChild(this);
			mouseEnabled = mouseChildren = false;
		}

		public static function getInstance():MapBlockContainer
		{
			if (_instance == null)
				_instance=new MapBlockContainer();
			return _instance;
		}

		public static function hasInstance():Boolean
		{
			return _instance != null;
		}

		public function init():void
		{
			this.mapId = MapData.MAPID;
//项目转换修改 this.resId = Pub_MapResModel(Lib.getObj(LibDef.PUB_MAP, SceneManager.instance.currentMapId.toString())).res_id;
			this.resId = XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId)["res_id"];
			this.maxX = Math.ceil(MapData.MAP_RES_WIDTH / MapDef.TILE_WIDTH);
			this.maxY = Math.ceil(MapData.MAP_RES_HEIGHT / MapDef.TILE_HEIGHT);
		}
		
		public function clear():void
		{
//			ImageUtils.cleanAllImage();
			this.oldTileX = -1;
			this.oldTileY = -1;
			var block:MapBlock;
			for (var key:String in curBlockDic)
			{
				block = curBlockDic[key];
				block.dispose();
				MapBlockPool.recycle(block);
				curBlockDic[key] = null;
				delete curBlockDic[key];
			}
			//			curBlockDic = new Dictionary();
		}
		
		/**
		 * 重新加载网格地图
		 * @param posX 像素坐标
		 * @param posY 像素坐标
		 * @param scaleRate 地图缩放比率，默认为1。当地图上展示御剑飞行时，地图要放大，环形方向将额外增加网格
		 */
		public function reloadTile(posX:int, posY:int, scaleRate:int = 1, drawNow:Boolean = false):void
		{
			//有可能地图数据未加载完成，但要求加载地图图片的协议已到，所以此时宽高都为0.因为此方法是一直刷新的，检测状态正确的时候赋值即可
			if (MapData.MAP_RES_WIDTH == 0 || MapData.MAP_RES_HEIGHT == 0)
				return;
			if(maxX <= 0 || maxY <= 0)
			{//不要每次移动都计算！
				maxX = Math.ceil(MapData.MAP_RES_WIDTH / MapDef.TILE_WIDTH);
				maxY = Math.ceil(MapData.MAP_RES_HEIGHT / MapDef.TILE_HEIGHT);
			}
			
//			var curTileX:int = MapCl.mapXToTile(posX);
//			var curTileY:int = MapCl.mapYToTile(posY);
			
			var curTileX:int = Math.ceil(posX / MapDef.TILE_WIDTH) - 1;
			var curTileY:int = Math.ceil(posY / MapDef.TILE_HEIGHT) - 1;
			if (curTileX < 0)
				curTileX = 0;
			if (curTileY < 0)
				curTileY = 0;
			if (this.oldTileX == curTileX && this.oldTileY == curTileY)
				return;
			oldTileX = curTileX;
			oldTileY = curTileY;
//			if (Action.instance.yuJianFly.fly)
//			{ //御剑飞行
//				H_BLOCK_NUM += 2;
//				V_BLOCK_NUM += 2;
//			}
			
			var curBlock:MapBlock = null;
			var bi:int = curTileX - 1;
			if (bi<0)
			{
				bi = 0;
			}
			var ei:int = curTileX + H_BLOCK_NUM;
			var bj:int = curTileY - 1;
			if (bj < 0)
			{
				bj = 0;
			}
			var ej:int = curTileY + V_BLOCK_NUM;
			var i:int = bi;
			var j:int = bj;
			var key:String = null;
			//取出可以重用的块
			var reuseVec:Vector.<MapBlock> = new <MapBlock>[];
			for (key in curBlockDic)
			{
				curBlock = curBlockDic[key];
				if(curBlock.tx < bi || curBlock.tx > ei || curBlock.ty < bj || curBlock.ty > ej)
				{
					curBlock.dispose();
					delete curBlockDic[key];
					reuseVec.push(curBlock);
				}
			}
			//计算需要加载的块
			var count:int = 0;
			for (i = bi; i <= ei; i++)
			{
				for (j = bj; j <= ej; j++)
				{
					curBlock = curBlockDic[i + "_" + j];
					if(curBlock || i < 0 || j < 0 || i >= maxX || j >= maxY)
						continue;
					curBlock = reuseVec.length ? reuseVec.pop() : MapBlockPool.pop();
					curBlock.x = i * MapDef.TILE_WIDTH;
					curBlock.y = j * MapDef.TILE_HEIGHT;
					curBlock.tx = i;
					curBlock.ty = j;
					curBlock.load(resId, i, j, drawNow);
					if(!curBlock.parent)
						addChild(curBlock);
					curBlockDic[i + "_" + j] = curBlock;
				}
			}
			while(reuseVec.length)
			{
				curBlock = reuseVec.pop();
				if(curBlock.parent)
					curBlock.parent.removeChild(curBlock);
				MapBlockPool.recycle(curBlock);
			}
		}
	}
}