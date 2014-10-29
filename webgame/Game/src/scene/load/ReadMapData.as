package scene.load
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_MapResModel;
	import common.utils.StringUtils;
	
	import engine.utils.HashMap;
	import engine.utils.compress.ArrDCode;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import scene.manager.ParsePathrFile;
	import scene.manager.SceneManager;
	import scene.utils.MapData;
	
	import world.WorldEvent;

	public class ReadMapData
	{
		//------------------------------------------------------------

		private static var isLoad:Boolean;
		private static var RecvFunc:Function;
		private static var Readmapid:int;

		//------------------------------------------------------------
		/**
		 * fux
		 *
		 * mapid,downid
		 */
		public static function ReadData(RecvFuncCall:Function, mapid:int):void
		{

			Readmapid=mapid;

			RecvFunc=RecvFuncCall;

			/*if(null != zip)
			{
				loadComplete();
				return;
			}*/

//			Debug.instance.traceMsg("read map info " + mapid);

			ParsePathrFile.instance.addEventListener(WorldEvent.PATHR_FILE_PARSE_COMPLETE, loadNext);
			ParsePathrFile.instance.load();

		}

		private static var _currentMapGridXmlLd:URLLoader;
		private static var _currentXml:String;
		private static var gridLdList:HashMap=new HashMap();
		private static var _currentKey:String;

		private static function loadNext(e:WorldEvent=null):void
		{
			//var mapResModel:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(Readmapid);
			var mapResModel:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(Readmapid) as Pub_MapResModel;
			_currentKey = Readmapid.toString() + "_" + mapResModel.res_id.toString();
			
			if(gridLdList.containsKey(_currentKey))
			{
				_currentMapGridXmlLd = gridLdList.getValue(_currentKey);
				_currentXml=StringUtils.trim(_currentMapGridXmlLd.data);
				loadComplete();
				
			}else{
			_currentMapGridXmlLd=new URLLoader();
			_currentMapGridXmlLd.dataFormat="text";

			_currentMapGridXmlLd.addEventListener(IOErrorEvent.IO_ERROR, ERROR_currentMapGridXmlLdHandler);
			_currentMapGridXmlLd.addEventListener(Event.COMPLETE, COMPLETE_currentMapGridXmlLdHandler);
			

			var url:String=GameIni.GAMESERVERS + "Map/DataMap/" + mapResModel.res_id.toString() + ".txt" + "?" + GameIni.MAP_VER;

			gridLdList.put(_currentKey,_currentMapGridXmlLd);
			_currentMapGridXmlLd.load(new URLRequest(url));
			}
		}
		
		
		public static function putMapDatas(key:String,value:ByteArray):void
		{
			key=key + "_" + key.toString();
			var loader:URLLoader=new URLLoader
			loader.data=value
			loader.dataFormat="text";
			gridLdList.put(key,loader);
		}
		private static var retryCount:int = 0;
		public static function ERROR_currentMapGridXmlLdHandler(event:IOErrorEvent):void
		{
						retryCount++;
			
			if(retryCount < 2){
				gridLdList.remove(_currentKey);
				flash.utils.setTimeout(loadNext,500);
			}
		}

		public static function COMPLETE_currentMapGridXmlLdHandler(event:Event):void
		{
			
			_currentXml=StringUtils.trim(_currentMapGridXmlLd.data);
			loadComplete();
		}

		
		public static var cacheMapData:HashMap=new HashMap();
		public static var mapShowHead:Boolean = false;//有的地图不能弹出boss头像
		private static function loadComplete():void
		{
			isLoad=true;
			var isRead:Boolean;
			//现已是标准xml格式			
			var mapdata:XML=XML(_currentXml);

			if (mapdata.hasOwnProperty("li")&&mapdata.li[0].hasOwnProperty("@data"))
			{
				MapData.MAP_RES_WIDTH=mapdata.li.@mw;
				MapData.MAP_RES_HEIGHT=mapdata.li.@mh;

				MapData.MAPID=Readmapid;
				MapData.MAPID_REAL=Readmapid;

				if (ShowLoadMap.hasInstance())
				{
					ShowLoadMap.instance.MAPID=Readmapid;
				}
				if (ReadMapData.cacheMapData.containsKey(Readmapid)==false)
				{
					ReadMapData.cacheMapData.put(Readmapid, ArrDCode.DCode(mapdata.li[0].@data, true));
				}
				MapData.MAPTileModel.map=ReadMapData.cacheMapData.getValue(Readmapid);
				isRead=true;
			}
			//------------------------------------------------------>>
			if (RecvFunc != null)
				RecvFunc(isRead);
			//boss头像显示
			var m_mode:Pub_MapResModel = XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
//			NewBossPanel.instance.isShowPanel();
			
			if(null != m_mode){
			if(m_mode.is_show_head==0){
				mapShowHead = true;
			}else{
				mapShowHead = false;
			}
			}
			
//			if(GameKing.grade ==3){
//				Body.instance.sceneKing.boss3map.push(GameKing);
//				NewBossPanel.instance.isShowPanel(GameKing,true);
//			}
		}
		
	}
}
