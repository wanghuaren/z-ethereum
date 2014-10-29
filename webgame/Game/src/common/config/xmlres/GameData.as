package common.config.xmlres
{
	import common.config.XmlConfig;
	import common.config.xmlres.map.MapTileLoader;
	import common.config.xmlres.lib.TablesLib;

	import engine.event.DispatchEvent;
	import engine.utils.Debug;

	import flash.utils.ByteArray;

	/**
	 * 游戏数据区
	 * @Author : wanghuaren
	 * @Data : 2014/08/11
	 */
	public class GameData
	{
		/**
		 * 整体cache开关
		 */
		private static var _OPEN:Boolean=true;
		// false;//true;
		/**
		 * 二级cache开关
		 *
		 * 如果 整体cache开关 关闭，则本开关设定无效
		 *
		 * 地图为二级cache，则表现为加载 A,B地图，不删除,
		 * B,C时删除A
		 *
		 */
		private static var _B_OPEN:Boolean=true;
		/**
		 * 大地图的地图块加载器池
		 */
		public static var mapTileLoader_pool:Vector.<MapTileLoader>=new Vector.<MapTileLoader>();
		/**
		 * 24
		 */
		public static const mapTileLoader_pool_size:int=24;

		/**
		 * 二级cache开关
		 *
		 * 如果 整体cache开关 关闭，则本开关设定无效
		 *
		 * 地图为二级cache，则表现为加载 A,B地图，不删除,
		 * B,C时删除A
		 *
		 */
		public static function get B_OPEN():Boolean
		{
			return _B_OPEN;
		}

		/**
		 * 静态资源
		 */
		/**
		 * 对象池开关状态
		 */
		public static function get OPEN():Boolean
		{
			return _OPEN;
		}

		public static function deepClone(v:DispatchEvent):DispatchEvent
		{
			var infoBA:ByteArray;
			if (v.getInfo as Array || v.getInfo as Object)
			{
				infoBA=new ByteArray();
				infoBA.writeObject(v.getInfo);
				infoBA.position=0;
				return new DispatchEvent(v.type, infoBA.readObject());
			}
			if (null != v.getInfo)
			{
				return new DispatchEvent(v.type, v.getInfo);
			}
			return new DispatchEvent(v.type, null);
		}

		/**
		 *
		 *
		 */
		public static function resetAllMapTileLoader():void
		{
			try
			{
				// loop use
				var i:int;
				var len:int;
				len=mapTileLoader_pool.length;
				for (i=0; i < len; i++)
				{
					//mapTileLoader_pool[i].loadCancel();
					mapTileLoader_pool[i].loadReset();
				} // end for
				//解锁
				GameData.setRunMapTileLoaderTaskLock(false, 0);
			}
			catch (exd:Error)
			{
				Debug.instance.traceMsg(exd.message + " function:resetAllMapTileLoader class:GameData");
				GameData.setRunMapTileLoaderTaskLock(false, 0);
			}
		}

		/**
		 * 静态资源文本数据，使用时才初始化
		 */
		public static function getToolsXml():TablesLib
		{
			return XmlManager.localres.getTableData(XmlConfig.TOOLXML);
		}
		/**
		 * 下载执行队列
		 *
		 * i = len-1 为此时加载你人物当前所处位置的场景图片，用户体验更好
		 */
		//public static var runMapTileLoaderTaskLock:Boolean = false;
		private static var _runMapTileLoaderTaskLock1:Boolean=false;
		private static var _runMapTileLoaderTaskLock2:Boolean=false;

		public static function get runMapTileLoaderTaskLock():Boolean
		{
			if (_runMapTileLoaderTaskLock1 || _runMapTileLoaderTaskLock2)
			{
				return true;
			}
			return false;
		}

		public static function setRunMapTileLoaderTaskLock(value:Boolean, threadNum:int=0):void
		{
			if (0 == threadNum)
			{
				_runMapTileLoaderTaskLock1=_runMapTileLoaderTaskLock2=value;
			}
			else if (1 == threadNum)
			{
				_runMapTileLoaderTaskLock1=value;
			}
			else if (2 == threadNum)
			{
				_runMapTileLoaderTaskLock2=value;
			}
			else if (-1 == threadNum)
			{
				throw new Error("threadNum can not equal -1");
			}
		}

		public static function get runMapTileLoaderTaskLockStrict():Boolean
		{
			if (_runMapTileLoaderTaskLock1 && _runMapTileLoaderTaskLock2)
			{
				return true;
			}
			return false;
		}

		public static function GetAndRunMapTileLoaderTaskThead():int
		{
			if (!_runMapTileLoaderTaskLock1)
			{
				_runMapTileLoaderTaskLock1=true;
				return 1;
			}
			if (!_runMapTileLoaderTaskLock2)
			{
				_runMapTileLoaderTaskLock2=true;
				return 2;
			}
			return -1;
		}

		/**
		 * 切场景时判断，正在加载或者队列中有待加载的
		 * runMapTileLoaderTaskLock or hasCanStartLoad
		 */
		public static function hasMapTileLoaderCanStartLoad():Boolean
		{
			// loop use
			var i:int;
			var len:int;
			len=mapTileLoader_pool.length;
			//Debug.instance.traceMsg("mapTileLoader_pool.length:" + len.toString());
			var has:Boolean;
			//for (i=0; i < len; i++)
			for (i=len - 1; i >= 0; i--)
			{
				// 如果未使用
				if (mapTileLoader_pool[i].isCanStartLoad)
				{
					//全局锁
					has=true;
					break;
				}
			}
			return has;
		}

		public static function runMapTileLoaderTaskList():void
		{
			//双线程需循环二次
			for (var k:int=0; k < 2; k++)
			{
				//正在执行下载
				//if(runMapTileLoaderTaskLock)
				if (runMapTileLoaderTaskLockStrict)
				{
					return;
				}
				// loop use
				var i:int;
				var len:int;
				len=mapTileLoader_pool.length;
				//Debug.instance.traceMsg("mapTileLoader_pool.length:" + len.toString());
				//for (i=0; i < len; i++)
				for (i=len - 1; i >= 0; i--)
				{
					// 如果未使用
					if (mapTileLoader_pool[i].isCanStartLoad)
					{
						//全局锁
						//GameData.runMapTileLoaderTaskLock = true;
						mapTileLoader_pool[i].loadAndSetResModel(GetAndRunMapTileLoaderTaskThead());
						break;
					}
				}
			}
		}

		/**
		 * getMapTileLoader
		 */
		public static function getMapTileLoader():MapTileLoader
		{
			// loop use
			var i:int;
			var len:int;
			if (mapTileLoader_pool.length < mapTileLoader_pool_size)
			{
				// 缺多少
				len=mapTileLoader_pool_size - mapTileLoader_pool.length;
				for (i=0; i < len; i++)
				{
					mapTileLoader_pool.push(new MapTileLoader());
				}
			}
			len=mapTileLoader_pool.length;
			for (i=0; i < len; i++)
			{
				// 如果未使用
				if (false == mapTileLoader_pool[i].isUse)
				{
					return mapTileLoader_pool[i];
				}
			}
			// 如果池满
			//Debug.instance.traceMsg("Warning:mapTileLoader对象池满");
			var added:MapTileLoader=new MapTileLoader();
			mapTileLoader_pool.push(added);
			return added;
		}

		public static function getVipTypeXml():TablesLib
		{
			return XmlManager.localres.getTableData(XmlConfig.VIPTYPEXML);
		}

		public static function getVipXml():TablesLib
		{
			return XmlManager.localres.getTableData(XmlConfig.VIPXML);
		}

		public static function getPubTaskXml():TablesLib
		{
			return XmlManager.localres.getTableData(XmlConfig.TASKXML);
		}

		public static function getDropXml():TablesLib
		{
			return XmlManager.localres.getTableData(XmlConfig.DROPXML);
		}

		public static function getInstanceXml():TablesLib
		{
			return XmlManager.localres.getTableData(XmlConfig.INSTANCEXML);
		}

		public static function getCombineXml():TablesLib
		{
			return XmlManager.localres.getTableData(XmlConfig.COMBINE);
		}

		public static function getHundredFightXml():TablesLib
		{
			return XmlManager.localres.getTableData(XmlConfig.HUNDREDFIGHT);
		}
	}
}
