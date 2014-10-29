package com.bellaxu.map
{
	import com.bellaxu.data.GameData;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.def.ResPriorityDef;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.compress.ArrDCode;
	import com.engine.core.tile.square.Square;
	import com.engine.core.tile.square.SquareGroup;
	import com.engine.core.tile.square.SquarePt;
	import com.engine.utils.Hash;

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.utils.StringUtils;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import scene.gprs.GameSceneGprs;
	import scene.manager.AlchemyManager;
	import scene.manager.SceneManager;
	import scene.utils.MapData;

	import ui.base.mainStage.UI_index;

	import world.WorldEvent;

	/**
	 * 地图加载
	 * @author BellaXu
	 */
	public class MapLoader
	{
		private static var RecvFunc:Function;
		private static var Readmapid:int;

		public static function ReadData(RecvFuncCall:Function, mapid:int):void
		{
			Readmapid=mapid;
			RecvFunc=RecvFuncCall;
			//项目转换修改 var m:Pub_MapResModel = Lib.getObj(LibDef.PUB_MAP, SceneManager.instance.currentMapId.toString());
			var m:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(Readmapid) as Pub_MapResModel;
			ResTool.load("Map/DataMap/" + m.res_id.toString() + ".txt", onLoadedMapData, null, null, null, ResPriorityDef.HIGH, URLLoaderDataFormat.TEXT);
		}

		public static function onLoadedMapData(url:String):void
		{
			if (!cacheMapData[url])
			{
				var mapdata:XML=ResTool.getXml(url);

				var ary:Array=[];
				ary.push(mapdata.li.@mw); //地图宽
				ary.push(mapdata.li.@mh); //地图高
//				ary.push(Readmapid);//地图id
				ary.push("010");//地图id
				ary.push(ArrDCode.DCode(mapdata.li[0].@data, true)); //阻挡数据

				cacheMapData[url]=ary;
			}
			//胜者为王没有做过地图资源复用,此处每次都要更改一下缓存
			cacheMapData[url][2]=Readmapid; //地图id

			fillMapData(cacheMapData[url]);

			if (RecvFunc != null)
				RecvFunc();
			//boss头像显示
//			var m_mode:Pub_MapResModel = Lib.getObj(LibDef.PUB_MAP, SceneManager.instance.currentMapId.toString());
			var m_mode:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
			if (m_mode)
				mapShowHead=m_mode.is_show_head == 0;

			SceneManager.instance.onLoadedMap();
			GameSceneGprs.SceneGprs.CompleteFunc();
		}

		private static function fillMapData(ary:Array):void
		{
			MapData.MAP_RES_WIDTH=ary[0];
			MapData.MAP_RES_HEIGHT=ary[1];
			MapData.MAPW=MapData.MAP_RES_WIDTH - MapData.TW;
			MapData.MAPH=MapData.MAP_RES_HEIGHT - MapData.TH;

			MapData.MAPID=ary[2];

			var value:Array=ary[3];
			MapData.MAPTileModel.map=value;
			AlchemyManager.instance.initMapData(MapData.MAPID, value);
//			smAstar(value);
		}

		public static var cacheMapData:Dictionary=new Dictionary();
		public static var mapShowHead:Boolean=false; //有的地图不能弹出boss头像

		public static function setMapData(array:Array):void
		{
			SquareGroup.getInstance().initialize();
			var dc:Hash=new Hash;
			var w:int=array.length;
			var h:int=array[0].length;

			for (var i:int=0; i < w; i++)
			{
				for (var j:int=0; j < h; j++)
				{
					var value:int=array[i][j];

					if (value == 2 || value == 1)
					{
						var square:Square=Square.createSquare();
						if (value == 2)
						{
//							square.isAlpha=true;
							square.type=1;
						}
						else
						{
							square.type=1;
						}
						square.setIndex(new SquarePt(i, j));

						dc.put(square.key, square);
					}
				}
			}
			SquareGroup.getInstance().reset(dc.hash);
		}

		public static var copyHash:Hash;
		public static var blockMode:Boolean=false;

		private static function smAstar(array:Array):void
		{
			if (blockMode)
			{
				copyHash=new Hash;
				SquareGroup.getInstance().initialize();
				var dc:Hash=new Hash;
				var w:int=array.length;
				var h:int=array[0].length;

				for (var i:int=0; i < w; i++)
				{
					for (var j:int=0; j < h; j++)
					{
						var value:int=array[i][j];
						if (value == 2 || value == 1)
						{
							var square:Square=Square.createSquare();
							if (value == 2)
							{
								//							square.isAlpha=true;
								square.type=1
							}
							else
							{
								square.type=1
							}
							square.setIndex(new SquarePt(i, j));
							copyHash.put(square.key, {type: square.type, num: 0});
							dc.put(square.key, square);
						}
					}
				}
				SquareGroup.getInstance().reset(dc.hash);
			}
			else
			{
				setMapData(array);
			}
		}
	}
}
