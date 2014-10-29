package com.bellaxu.res
{
	import com.bellaxu.util.SysUtil;
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.net.URLLoaderDataFormat;
	import flash.system.ApplicationDomain;

	/**
	 * 取资源公共方法
	 * @author BellaXu
	 */
	public class ResTool
	{
		/**
		 * 当前加载完的个数
		 */
		public static function get preLoadIndex():uint
		{
			return ResPreLoader.preloadIndex;
		}
		
		/**
		 * 获取预加载队列的长度
		 */
		public static function get preLoadLength():uint
		{
			var queue:Array = ResPreLoader.LOAD_QUEUE;
			var len:uint;
			for(var i:int = 0;i < queue.length;i++)
			{
				len += queue[i].length;
			}
			return len;
		}
		
		/**
		 * 开始预加载
		 */
		public static function startPreLoad(onComplete:Function, onProgress:Function, onError:Function):void
		{
			ResPreLoader.loadStart(onComplete, onProgress, onError);
		}
		
		/**
		 * 继续预加载
		 */
		public static function continuePreLoad(onComplete:Function = null):void
		{
			ResPreLoader.loadContinue(onComplete);
		}
		
		public static function get preloadingUrl():String
		{
			if(ResPreLoader.currentState < ResPreLoader.LOAD_QUEUE.length && ResPreLoader.currentIndex < ResPreLoader.LOAD_QUEUE[ResPreLoader.currentState].length)
				return ResPreLoader.LOAD_QUEUE[ResPreLoader.currentState][ResPreLoader.currentIndex];
			return "游戏资源";
		}
		
		public static function init(stage:Stage):void
		{
			ResMcMgr.init(stage);
		}
		
		/**
		 * 注册McMgr的舞台
		 */
		public static function render():void
		{
			ResMcMgr.render();
		}
		
		/**
		 * 设置角色列表
		 */
		public static function registRoleList(list:Array):void
		{
			ResMcMgr.leadRoleSkin = list;
		}
		
		/**
		 * 根据xml路径获取ResMc对象
		 */
		public static function getResMc(xmlUrl:String):ResMc
		{
			return ResMcMgr.getByXml(xmlUrl);
		}
		
		/**
		 * 加载资源
		 */
		public static function load(url:String, onComplete:Function = null, onProgress:Function = null, onError:Function = null, domain:ApplicationDomain = null, priority:uint = 0, format:String = URLLoaderDataFormat.BINARY, ver:String = null):void
		{
			ResLoader.getInstance().loadRes(url, onComplete, onProgress, onError, domain, priority, format, ver);
		}
		
		/**
		 * unload
		 */
		public static function unload(url:String):void
		{
			ResLoader.getInstance().disposeRes(url);
		}
		
		/**
		 * 取消加载资源
		 */
		public static function cancelLoad(url:String, gc:Boolean = true):void
		{
			ResLoader.getInstance().cancelRes(url);
		}
		
		/**
		 * 是否已经加载完毕
		 */
		public static function isLoaded(url:String):Boolean
		{
			return ResLoader.getInstance().isLoaded(url);
		}
		
		/**
		 * 是否正在加载
		 */
		public static function isLoading(url:String):Boolean
		{
			return ResLoader.getInstance().isLoading(url);
		}
		
		/**
		 * 清除人物资源
		 */
		public static function clear():void
		{
			ResBmd.delAllBmd();
		}
		
		/**
		 * 切地图时释放内存
		 */
		public static function clearWhenChangeMap():void
		{
			MapResLoader.getInstance().clearMapRes();
//			ResLoader.getInstance().clearMapRes();
			SysUtil.gc();
		}
		
		/**
		 * 取消回调，回调类型见ResDef
		 */
		public static function clearNotify(url:String, notify:Function):void
		{
			ResLoader.getInstance().clearNotify(url, notify);
		}
		
		/**
		 * 域中是否存在链接
		 */
		public static function hasLink(link:String, domain:ApplicationDomain = null):Boolean
		{
			if(domain == null)
				domain = ApplicationDomain.currentDomain;
			return domain.hasDefinition(link);
		}
		
		public static function getAppMc(link:String):*
		{
			return getMc(null, link);
		}
		
		public static function getAppBmd(link:String):*
		{
			return getBmd(null, link);
		}
		
		public static function getAppCls(link:String):Class
		{
			return getCls(null, link);
		}
		
		/**
		 * 取资源path中的linkMc
		 */
		public static function getMc(path:String, link:String = null):*
		{
			return ResLoader.getInstance().getLoadedInstance(path, link);
		}
		
		/**
		 * 取资源中的link位图
		 */
		public static function getBmd(path:String, link:String = null):BitmapData
		{
			return ResLoader.getInstance().getLoadedBitmapData(path, link);
		}
		
		/**
		 * 取资源中的class
		 */
		public static function getCls(path:String, link:String = null):Class
		{
			return ResLoader.getInstance().getDefClass(path, link);
		}
		
		/**
		 * 取资源的域
		 */
		public static function getDomain(url: String):ApplicationDomain
		{
			return ResLoader.getInstance().getDomain(url);
		}
		
		/**
		 * 取加载完的xml
		 */
		public static function getXml(path:String):XML
		{
			return ResXml.getXMLByPath(path);
		}
		
		/**
		 * 取lib中的xml
		 */
		public static function getLibXml(lib:String, path:String):XML
		{
			var xml:XML = ResXml.getXMLByPath(path, lib);
			if(xml)
				return xml;
			var path2:String = path;
			while (path2.indexOf("/") >= 0)
			{
				path2 = path2.replace("/", "___");
			}
			path2 = path2.replace(".", "__");
			var domain:ApplicationDomain = getDomain(lib);
			if (domain && domain.hasDefinition(path2))
			{
				var cl:Class = domain.getDefinition(path2) as Class;
				xml = XML(new cl());
				ResXml.saveLibXml(lib, path, xml);
				return xml;
			}
			return null;
		}
		
		/**
		 * 获取资源版本
		 */
		public static function getVer(url:String):String
		{
			return ResTime.getTime(url);
		}
	}
}