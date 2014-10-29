package scene.manager
{
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_MapResModel;

	import engine.utils.HashMap;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	import scene.utils.MapCl;
	import scene.utils.MapData;

	import world.WorldEvent;

	[Event(name="pathrFileParseComplete", type="world.WorldEvent")]

	public class ParsePathrFile extends EventDispatcher
	{
		private static var _instance:ParsePathrFile;

		public static function get instance():ParsePathrFile
		{
			if (!_instance)
			{
				_instance=new ParsePathrFile();
			}

			return _instance;
		}

		private var ld:URLLoader;

		private var ldList:HashMap=new HashMap();

		private var m:Pub_MapResModel;

		public function load():void
		{
			var _currentMapId:int=SceneManager.instance.currentMapId;

			//model = XmlManager.localres.getPubMapXml.getResPath(_currentMapId);
			m=XmlManager.localres.getPubMapXml.getResPath(_currentMapId) as Pub_MapResModel ;

			var k:String=m.res_id.toString() + ".amd" + "?" + GameIni.MAP_VER;

			if (ldList.containsKey(k))
			{
				COMPLETE2(ldList.getValue(k));

			}
			else
			{
				if (ld != null)
				{
					ld.removeEventListener(Event.COMPLETE, COMPLETE_ldHandler);
					if (ld.bytesLoaded > 0)
					{
						ld.close();
					}
					ld=null;
				}
				ld=new URLLoader();
				ld.dataFormat="text";
				ld.addEventListener(Event.COMPLETE, COMPLETE_ldHandler);
				ld.addEventListener(IOErrorEvent.IO_ERROR, loadErr);
				var url:String=GameIni.GAMESERVERS + "Map/DataMap/" + m.res_id.toString() + ".amd" + "?" + GameIni.MAP_VER;
				ld.load(new URLRequest(url));
			}
		}

		private function loadErr(e:IOErrorEvent):void
		{
			trace("加载地图AMD文件错误")
		}

		public function COMPLETE_ldHandler(event:Event):void
		{
			ld.removeEventListener(Event.COMPLETE, COMPLETE_ldHandler);

			var k:String=m.res_id.toString() + ".amd" + "?" + GameIni.MAP_VER;

			var prFile:PathrFileInfo=new PathrFileInfo();

			prFile.ld=ld;

			prFile.pathrArr=parse(ld.data);
			prFile.mapW=prFile.pathrArr.shift();
			prFile.mapH=prFile.pathrArr.shift();

			ldList.put(k, prFile);

			COMPLETE2(prFile);

		}

		public function putData(res_id:String, byte:ByteArray):void
		{
			var k:String=res_id.toString() + ".amd" + "?" + GameIni.MAP_VER;

			var prFile:PathrFileInfo=new PathrFileInfo();
			var ld:URLLoader=new URLLoader
			byte.position=0
			ld.data=byte
			prFile.ld=ld;

			prFile.pathrArr=parse(ld.data);
			prFile.mapW=prFile.pathrArr.shift();
			prFile.mapH=prFile.pathrArr.shift();

			ldList.put(k, prFile);


		}

		public function COMPLETE2(prFile:PathrFileInfo):void
		{
			//宽高需减35，冯峰
			//因寻路数据方面需求
//			MapData.MAPW=prFile.mapW - 35;
			MapData.MAPW=prFile.mapW - 64;
//			MapData.MAPH=prFile.mapH - 35;
			MapData.MAPH=prFile.mapH - 32;

			//实际宽高不用减35
			SceneManager.instance.currentMapWidth=prFile.mapW;
			SceneManager.instance.currentMapHeight=prFile.mapH;

			var mapId:int=SceneManager.instance.currentMapId;

//			AlchemyManager.instance.initMap(mapId, prFile.mapW, prFile.mapH, new Array().concat(prFile.pathrArr));

			var we:WorldEvent=new WorldEvent(WorldEvent.PATHR_FILE_PARSE_COMPLETE, prFile.pathrArr);

			this.dispatchEvent(we);
		}


		public function parse(pathr:String):Array
		{
			var pathrFilePattern:RegExp=/\r\n/g;

			//去换行符
			pathr=pathr.replace(pathrFilePattern, "");

			//根据,号分割
			return pathr.split(",");

			//------------------------------------------------------------------
			//var testStr:String = "4200,4200,0,120,63,120,66,86,5,22,8,27,7,23,104,120,0,63,50,63,6,19,31,46,30,42,27,38,10,21,74,89,43,54,38,50,52,61,45,54,21,30,59,70,27,36,86,94,9,19,86,94,35,43,15,24,33,40,24,31,34,42,25,32,53,61,36,43,1,10,59,66,36,45,11,19,1,7,27,35,21,27,32,38,54,61,46,53,30,36,83,89,23,29,1,6,13,18,3,8,18,23,7,13,31,36,53,59,30,35,62,74,22,27,85,90,29,34,20,27,23,27,38,42,10,15,41,45,24,30,46,50,11,15,54,58,26,30,94,98,13,17,5,8,8,11,15,20,23,26,19,23,4,7,22,25,52,55,27,36,42,45,29,36,7,10,29,35,27,30,43,46,3,6,46,49,36,39,47,50,8,11,50,53,57,61,53,73,58,61,57,60,46,49,63,66,8,19,70,74,27,30,70,74,51,54,82,86,40,43,86,89,6,9,86,89,19,22,89,92,48,52,4,7,32,34,6,8,14,18,8,11,1,3,10,15,36,38,13,15,33,36,23,25,5,7,24,27,27,29,35,37,21,25,36,39,42,44,38,40,15,17,43,45,22,24,48,50,15,17,49,56,19,21,49,51,36,38,50,53,51,53,53,55,50,52,55,57,4,6,55,57,48,51,60,62,4,6,60,62,23,25,60,62,45,47,64,66,4,6,66,69,41,43,70,73,54,56,70,72,56,58,71,74,49,51,72,74,46,49,73,77,59,61,74,78,22,24,81,83,22,24,84,86,38,40,84,92,59,61,89,91,7,9,89,92,43,45,89,91,45,48,90,92,32,35,94,96,11,13,94,96,35,40,2,3,18,19,6,7,31,32,7,8,1,2,7,8,7,8,7,8,13,14,9,11,3,4,9,10,36,37,10,11,4,6,11,12,23,24,13,15,23,24,13,14,32,33,14,15,38,39,16,19,26,27,16,17,27,28,19,20,2,4,19,24,40,41,20,21,3,4,20,21,51,52,20,22,53,54,21,22,52,53,22,23,3,4,22,25,60,61,22,97,62,63,23,25,55,56,24,25,56,57,25,26,6,7,25,27,42,43,25,27,52,53,26,27,43,44,28,29,8,10,30,31,30,32,31,32,45,46,34,36,6,7,35,36,5,6,35,36,28,30,35,38,53,54,36,37,29,30,36,37,45,46,38,39,17,18,38,39,19,20,39,43,42,43,40,41,15,16,40,41,24,25,40,41,27,30,41,44,51,52,42,43,10,13,42,43,23,24,43,44,1,3,43,45,6,7,45,46,12,14,46,48,39,40,47,48,15,16,47,49,20,21,48,50,7,8,49,50,6,7,49,50,17,18,50,51,55,57,51,55,5,6,51,52,36,37,51,52,56,57,52,53,50,51,54,56,21,22,54,55,22,23,54,55,25,26,54,55,49,50,56,57,19,20,56,57,47,48,57,58,49,50,58,59,27,30,58,60,45,46,60,61,47,48,61,62,25,27,62,63,5,6,62,64,45,46,63,64,4,5,63,65,7,8,63,66,21,22,65,66,6,7,65,66,19,21,66,82,4,5,66,68,36,37,66,67,37,38,66,67,40,41,66,68,43,44,66,67,44,45,69,70,41,42,69,70,57,58,70,73,30,31,71,72,31,33,73,74,45,46,74,76,24,25,74,75,25,26,74,76,42,43,74,83,54,55,78,79,22,23,80,81,22,23,80,82,42,43,81,82,41,42,81,84,60,61,82,83,24,26,83,88,22,23,83,84,39,40,84,85,29,31,85,86,37,38,86,90,34,35,89,91,19,20,89,90,20,21,89,90,28,29,89,91,52,53,90,91,31,32,91,93,8,9,92,93,34,35,92,93,43,44,92,94,60,61,94,95,17,19,94,95,40,42,96,97,12,13,96,97,17,18,98,99,14,17,103,104,40,41,";

			//var testStr:String = "4200,4200,0,4200,0,4200,";
			//return testStr.split(",");
		}



	}
}
