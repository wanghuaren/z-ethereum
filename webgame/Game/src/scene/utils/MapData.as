package scene.utils 
{
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.model.lib.Lib;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_MapResModel;
	
	import engine.event.DispatchEvent;
	import engine.utils.HashMap;
	
	import flash.display.Sprite;
	
	import netc.Data;
	
	import scene.manager.SceneManager;
	
	import world.map.eidiot.MapTileModel;

	public class MapData 
	{
		public static const TW : int = 64;
		public static const TH : int = 32;
		//------------------------------------------------------------
		public static var GAME_MAP:Sprite;
		public static var MAPW : int;
		public static var MAPH : int;
		
		public static var MAP_RES_WIDTH:int;
		public static var MAP_RES_HEIGHT:int;
		
		public static function get MAPW_REAL():int
		{
			return MAPW;
			//return MAPW + 35;
		}

		public static function get MAPH_REAL():int
		{
			return MAPH;
			//return MAPH + 35;
		}
		public static var MAPID : int;
		private static var _MAPID_REAL:int;
		
		public static function get MAPDATA():Array
		{
			return MAPTileModel.map;
		}
		
		private static var _boatMap:HashMap = new HashMap();
		public static function get MAPDATA_Boat():Array
		{
			var ex_id:int = Data.myKing.Exercise2;
			if(_boatMap.containsKey(ex_id))
				return _boatMap.getValue(ex_id) as Array;
			
			var arr:Array = [];
			arr=XmlManager.localres.FlyMaskPathXml.getResPath2(ex_id) as Array;
						var j:int = 0;
						var jLen:int = arr.length;
//项目转换		var m:Pub_Fly_Mask_PathResModel= Lib.getObj(LibDef.PUB_FLY_MASK_PATH, ex_id.toString());
//			if(m)
//			{
//				arr = m.alpha_rect.split("|");
//				jLen = arr.length;
//				var pointArrTmp:Array = [];
//				for(j = 0;j < jLen;j++)
//				{
//					var p:Array = arr[j].split(",");
//					if(2 == p.length)
//						pointArrTmp.push(p);				
//				}
//				arr = pointArrTmp;
//			}
			var mapDC:Array = MAPDATA.concat([]);
			for(j = 0;j < jLen;j++)
			{
				var p_x:int = arr[j][0];
				var p_y:int = arr[j][1];
				
				if (mapDC.hasOwnProperty(p_x) && mapDC[p_x].hasOwnProperty(p_y))
					mapDC[p_x][p_y] = 2;
			}
			_boatMap.put(ex_id,mapDC);
			return mapDC;
		}
				public static var MAP_WEATHER : Sprite;		//------------------------------------------------------------
		public static var MAP_TILE:Sprite=null;
		public static var MAP_BODY:Sprite=null;
		public static var MAP_BODY2:Sprite=null;
		public static var MAP_DROP:Sprite=null;
		public static  var MAPTileModel : MapTileModel = new MapTileModel();		
		//------------------------------------------------------------
		public static var MapChangeSeekId : int;
		
		public static function set MAPID_REAL(value:int):void
		{
			_MAPID_REAL=value;
		}
		public static function get getThisMapMusicUrl() : String
		{
//项目转换			var mode:Pub_MapResModel = Lib.getObj(LibDef.PUB_MAP, SceneManager.instance.currentMapId.toString());
			var mode:Pub_MapResModel=XmlManager.localres.getPubMapXml.getResPath(SceneManager.instance.currentMapId) as Pub_MapResModel;
			var list:Array;
			
			if(mode.music.indexOf(",") > 0)
			{
				list = mode.music.split(",");
				return list[0];
			}
			return mode.music;
		}

		public static function DispatchEvents(EventString : String,EventData : Object) : void 
		{
			LayerDef.bodyLayer.dispatchEvent(new DispatchEvent(EventString, EventData));
		}

		public static function AddEventListener(EventString : String,RecvFunc : Function) : void 
		{
			LayerDef.bodyLayer.removeEventListener(EventString, RecvFunc);
			LayerDef.bodyLayer.addEventListener(EventString, RecvFunc);
		}

		public static function RemoveEventListener(EventString : String,RecvFunc : Function) : void 
		{
			LayerDef.bodyLayer.removeEventListener(EventString, RecvFunc);
		}
	}
}
