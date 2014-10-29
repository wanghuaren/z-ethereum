package scene.load {
	import common.config.MapTileResModelConfig;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.managers.Lang;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import world.FileManager;
	import world.WorldDispatcher;
	import world.WorldEvent;

	/**
	 * @author shuiyue
	 */
	public class GameMosaicMap {
		private static var load : Loader;
		//private static var beiW : Number;		//private static var beiH : Number;
		
		/**
		 * 10倍的地图缩放关系
		 */ 
		public static const beiW:int = 10;
		public static const beiH :int = 10;
		
		/**
		 * 场景缩略图资源，声明为public类型，方便外部接口调用 
		 */
		public static var TempData : BitmapData = null;
		private static var TempDataNull : BitmapData = new BitmapData(MapTileResModelConfig.TILE_WIDTH, MapTileResModelConfig.TILE_HEIGHT, true, 0x000000);
		private static var mapres : Dictionary;// = new Dictionary(true);
		private static var RecvFunc : Function = null;
		//private static var downtime : int = 0;		private static var myBytesLoaded : Number = 0;		private static var myBytesTotal : Number = 0;

		private static var MAPID:int;
		
		//------- 地图二级缓存  begin ---------------------
		private static var TempData1:BitmapData;
		private static var mapres1:Dictionary;		
		private static var TempData1_MAPID:int = -1;
		
		private static var TempData2:BitmapData;
		private static var mapres2:Dictionary;	
		private static var TempData2_MAPID:int= -1;
		//------- 地图二级缓存  end ----------------------
		
		public static function hasMapId():Boolean
		{
			if( -1 != TempData1_MAPID)
			{
				if(TempData1_MAPID == MAPID)
				{
					return true;
				}
			}
			
			if( -1 != TempData2_MAPID)
			{
				if(TempData2_MAPID == MAPID)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function LoadAndUpdate(RecvFunc : Function) : void {
			
			//置MAPID
			MAPID=MapData.MAPID;
			
			//
			GameMosaicMap.RecvFunc = RecvFunc;
			
//			//如果存在mapid 直接转COMPLETE事件中处理
			var needLoadMosaicMap:Boolean = false;//true;
//			

			if(needLoadMosaicMap)
			{
				//clear ld
				try {

					if(null != GameMosaicMap.load)
					{
						GameMosaicMap.load.close();
					}
					
				} catch (e:Error) {
					// Don't throw close errors.
				}
				
				//
				try
				{
					if (TempData!=null){
						TempData.dispose();
					}
					TempData = null;
					
					if(null != GameMosaicMap.load)
					{
						GameMosaicMap.load.unloadAndStop(false);
					}
					
				}catch(exc : Error) 
				{
					//
				}
				
				load = new Loader();
				
				//var model:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId);
				var model:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
				
				var mosaicUrl:String = FileManager.instance.getMosaicMapById(model.res_id.toString());
				
				load.load(new URLRequest(mosaicUrl));
				load.contentLoaderInfo.addEventListener(Event.COMPLETE, COMPLETE1);//注意现在不是COMPLETE
				load.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
				load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ERR);
				load.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ERR);
			}else
			{
				COMPLETE2();
			}
			
		}

		private static function loadProgress(event : ProgressEvent) : void {
			//if(myBytesLoaded == 0)downtime = getTimer();
			myBytesLoaded = event.bytesLoaded;			myBytesTotal = event.bytesTotal;
			//setBarScaleX(myBytesLoaded / myBytesTotal);			//setBarScaleX(myBytesLoaded / myBytesTotal, "下载速度：" + Number(Math.round(myBytesLoaded / int(getTimer() - downtime) * 100) / 100) + " K/s");
		
			var barPercent:int = int(myBytesLoaded / myBytesTotal);
			//var txtStr:String = "加载马赛克地图..." + barPercent + "%";
			
			//var txtStr:String = "加载马赛克地图...";			
			var txtStr:String = Lang.getLabel("10104_loading_mosaic_map") + "...";
			
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.TXT_INFO,txtStr));
			WorldDispatcher.instance.dispatchEvent(new WorldEvent(WorldDispatcher.BAR_PERCENT,barPercent));
			
		}
		

		private static function ERR(e : ErrorEvent) : void {
			TempData = TempDataNull;
			if(GameMosaicMap.RecvFunc != null)GameMosaicMap.RecvFunc.call();
		}
		
		private static function COMPLETE1(e : Event) : void {
			TempData = (load.content as Bitmap).bitmapData;
			
			//fux
			GameMosaicMap.load.removeEventListener(Event.COMPLETE, COMPLETE1);
			GameMosaicMap.load.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			GameMosaicMap.load.removeEventListener(IOErrorEvent.IO_ERROR, ERR);			
			GameMosaicMap.load.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ERR);
			
//			//
//			if( -1 == TempData1_MAPID &&  -1 == TempData2_MAPID)
//			{
//				//第一次进入地图
//				TempData1_MAPID = MAPID;
//				mapres1 = mapres =  new Dictionary(true);//Dictionary(true);
//				TempData1 = TempData;
//					
//			}else if(hasMapId())
//			{
//				//A,B地图间切换
//				if( -1 != TempData1_MAPID && TempData1_MAPID == MAPID)
//				{
//					mapres = mapres1;
//					TempData = TempData1;	
//						
//				}else if( -1 != TempData2_MAPID && TempData2_MAPID == MAPID)
//				{
//					mapres = mapres2;
//					TempData = TempData2;	
//				}
//					
//			}
//			else if( -1 != TempData1_MAPID &&  -1 == TempData2_MAPID)
//			{
//				//第一次切换地图	
//				TempData2_MAPID = MAPID;
//				mapres2 = mapres = new Dictionary(true);//Dictionary(true);				
//				TempData2 = TempData;				
//					
//			}
//			else 
//			{
//				//B,C地图间切换
//				//
//				TempData1_MAPID = TempData2_MAPID;
//				mapres1 = mapres2;
//				TempData1 = TempData2;
//					
//				//
//				TempData2_MAPID = MAPID;
//					
//				//销毁mapres
//				for (var key:String in mapres)
//				{
//					//Debug.instance.traceMsg(key);
//					var bd:BitmapData = mapres[key] as BitmapData;
//						
//					if(null != bd)bd.dispose();
//						
//					delete mapres[key];
//				}
//					
//				mapres2 = mapres =new Dictionary(true);//Dictionary(true);		
//				TempData2 = TempData;
//			}		
			
			//
			COMPLETE();
		}
		
		private static function COMPLETE2():void
		{
			//
			COMPLETE();
		
		}
		
		private static function COMPLETE():void
		{
									
			//10倍的地图缩放关系
			//该变量已改成常量
			//beiW = 10;//MapData.MAPW / 600;
			//beiH = 10;//MapData.MAPH / 360;
			if(GameMosaicMap.RecvFunc != null)GameMosaicMap.RecvFunc.call();
		
		}

		public static function getBitMapData(dx : int,dy : int) : BitmapData {
					
			if(TempData != null) {
				if(mapres.hasOwnProperty(dx + "_" + dy)) {			
					return mapres[dx + "_" + dy] as BitmapData;
				} else {
					
					//var BitMapData : BitmapData = new BitmapData(256 / beiW, 160 / beiH, true, 0x000000);
				
					var BitMapData : BitmapData = new BitmapData(MapTileResModelConfig.TILE_WIDTH / beiW, MapTileResModelConfig.TILE_HEIGHT / beiH, true, 0x000000);
					
					//if(TempData != null)BitMapData.copyPixels(TempData, new Rectangle(dx / beiW, dy / beiH, 256 / beiW, 160 / beiH), new Point(0, 0));
					BitMapData.copyPixels(TempData, new Rectangle(dx / beiW, dy / beiH, MapTileResModelConfig.TILE_WIDTH / beiW, MapTileResModelConfig.TILE_HEIGHT / beiH), new Point(0, 0));
					mapres[dx + "_" + dy] = BitMapData;
					return BitMapData;
					//return TempDataNull;
					
					
					
				}
			} else {
				return TempDataNull;
			}
			
		
		}
	}
}
