package com.bommie.load
{
	import com.bommie.mgr.TimerMgr;
	import com.bommie.utils.AmdUtil;
	import com.bommie.utils.PathUtil;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import com.bommie.pool.ResBMD;
	import com.bommie.pool.RoleXMLPool;

	public final class ResLoader
	{
		private const THREAD_NUM:uint=10;
		private const ERROR_TIMES:uint=3;
		private static var _instance:ResLoader;
		/**
		 * 正在加载的对象[Loader]=url,URLLoader和Loader
		 * */
		private var _urlDic:Dictionary;
		/**
		 * 已加载的域(Loader)
		 * */
		private var _loaderDic:Dictionary;
		/**
		 * 正在加载中,截止onComplete事件,数据变为最终的SWF
		 * */
		private var _loadingDic:Dictionary;
		/**
		 * 每个URL对应的处理方法
		 * */
		private var _paramsDic:Dictionary;
		/**
		 * HTTP请求加载队列
		 * */
		private var _httpUrlList:Array;
		/**
		 * 当前Loader的数量
		 * */
		private var _curLoaderCount:int;
		/**
		 * 延时处理_paramsDic中的对象
		 * */
		private var _delayList:Vector.<String>; //延时通知加载完的更新，只处理mc和位图资源

		public function ResLoader()
		{
			_urlDic=new Dictionary();
			_loadingDic=new Dictionary();
			_loaderDic=new Dictionary();
			_paramsDic=new Dictionary();
			_httpUrlList=[];
			_delayList=new <String>[];
			TimerMgr.getInstance().add(33, delayHandler);
		}

		public static function getInstance():ResLoader
		{
			if (_instance == null)
				_instance=new ResLoader();
			return _instance;
		}

		public function isLoading(url:String):Boolean
		{
			return _loadingDic[url];
		}

		public function isLoaded(url:String):Boolean
		{
			return _loaderDic[url] && !_loadingDic[url];
		}

		/**
		 * @param url : 资源相对路径
		 * @param completeFunc : 带url参数的回调方法(normal)，若为dat，同时带byte
		 * @param progressFunc : 带bytesLoaded和bytesTotal参数的回调方法
		 * @param errorFunc : 带url参数的回调方法
		 * @param domain : 域
		 * @param priority : 优先级，默认0为普通级别，如果希望最优加载可以设为最高
		 */
		public function loadRes(url:String, onComplete:Function=null, onProgress:Function=null, onError:Function=null, domain:ApplicationDomain=null, priority:uint=0, format:String=URLLoaderDataFormat.BINARY, ver:int=0):void
		{
			if (url == null)
				return;
			var m_resUnit:ResUnit=_paramsDic[url] as ResUnit;
			if (isLoading(url))
			{
				if (onComplete != null && m_resUnit.onComplete.indexOf(onComplete) < 0)
					m_resUnit.onComplete.push(onComplete);
				if (onProgress != null && m_resUnit.onProgress.indexOf(onProgress) < 0)
					m_resUnit.onProgress.push(onProgress);
				if (onError != null && m_resUnit.onError.indexOf(onError) < 0)
					m_resUnit.onError.push(onError);
				return;
			}
			_loadingDic[url]=true;
			if (_loaderDic[url])
			{
				if (onProgress != null)
					onProgress(100, 100);
				if (onComplete != null)
				{
					if (m_resUnit == null)
					{
						m_resUnit=new ResUnit();
						_paramsDic[url]=m_resUnit;
					}
					if (m_resUnit.onComplete.indexOf(onComplete) < 0)
						m_resUnit.onComplete.push(onComplete);
				}
				if (_delayList.indexOf(url) < 0)
					_delayList.push(url);
				return;
			}
			//插队优化
			var i:int=0;
			for (i=0; i < _httpUrlList.length; i++)
			{
				var params:Object=_paramsDic[_httpUrlList[i]];
				if (params.priority <= priority)
				{
					_httpUrlList.splice(i, 0, url);
					break;
				}
			}
			if (i >= _httpUrlList.length)
				_httpUrlList.push(url);
			m_resUnit=new ResUnit();
			if (onComplete != null)
				m_resUnit.onComplete.push(onComplete);
			if (onError != null)
				m_resUnit.onError.push(onError);
			if (onProgress != null)
				m_resUnit.onProgress.push(onProgress);
			m_resUnit.domain=domain;
			m_resUnit.priority=priority;
			m_resUnit.format=format;
			m_resUnit.ver=ver;
			_paramsDic[url]=m_resUnit;
			sendHTTPwebRequest();
		}

		/**
		 * 开始一个HTTP请求
		 * */
		private function sendHTTPwebRequest():void
		{
			if (_curLoaderCount >= THREAD_NUM || _httpUrlList.length < 1)
				return;
			var url:String=_httpUrlList.shift();
//            var urlLoader:URLLoader = URLLoaderPool.pop();
			var urlLoader:URLLoader=new URLLoader;
			_urlDic[urlLoader]=url;
			_curLoaderCount++;
			urlLoader.dataFormat=_paramsDic[url].format;
			addLoaderEvent(urlLoader);
			urlLoader.load(new URLRequest(PathUtil.getFullPath(url) + "?ver=" + _paramsDic[url].ver));
		}

		private function urlLoaderCompelteHandler(evt:Event):void
		{
			removeLoaderEvent(evt.target);
			//正在加载数减1，继续加载下一个
			_curLoaderCount--;
			sendHTTPwebRequest();
			var url:String=_urlDic[evt.target];
			_urlDic[evt.target]=null;
			delete _urlDic[evt.target];
			var params:ResUnit=_paramsDic[url] as ResUnit;
			if (params.format == URLLoaderDataFormat.TEXT)
			{
				RoleXMLPool.instance.saveTxtXml(url, evt.target.data);
				delete _paramsDic[url];
				delete _loadingDic[url];
				_loaderDic[url]=true;
				for each (func in params.onComplete)
				{
					func(url);
				}
				return;
			}
			var bytes:ByteArray=evt.target.data as ByteArray;
			var func:Function=null;
			switch (url.substr(-3, 3))
			{
				case "txt": //txt
				case "xml": //xml文件
					RoleXMLPool.instance.saveXMLByBytes(url, bytes);
					delete _paramsDic[url];
					delete _loadingDic[url];
					_loaderDic[url]=true;
					for each (func in params.onComplete)
					{
						func(url);
					}
					break;
				case "dat": //二进制“键－值”数据
					ResDat.saveDatByBytes(url, bytes);
					delete _paramsDic[url];
					delete _loadingDic[url];
					_loaderDic[url]=true;
					for each (func in params.onComplete)
					{
						func(url);
					}
					break;
				case "lib": //工具生成的游戏配置(原lib.swf)
//					Lib.save(bytes);
					delete _paramsDic[url];
					delete _loadingDic[url];
					_loaderDic[url]=true;
					for each (func in params.onComplete)
					{
						func(url);
					}
					break;
				case "amd": //加过密的swf
					bytes=AmdUtil.decodeBytes(bytes);
				case "swf": //swf
				default:
					var loader:Loader=new Loader();
					_urlDic[loader.contentLoaderInfo]=url;
					_loaderDic[url]=loader;
					addLoaderEvent(loader.contentLoaderInfo);
					var lc:LoaderContext=new LoaderContext();
					lc.allowCodeImport=true;
					lc.imageDecodingPolicy=ImageDecodingPolicy.ON_LOAD;
					lc.applicationDomain=params.domain ? params.domain : new ApplicationDomain();
					loader.loadBytes(bytes, lc);
					break;
			}
		}

		private function onCompleteHandler(evt:Event):void
		{
			removeLoaderEvent(evt.target);
			var url:String=_urlDic[evt.target];
			delete _urlDic[evt.target];
			//存储位图
			if (url.substr(-2, 2) == "ng" || url.substr(-2, 2) == "pg")
				ResBMD.instance.saveBmd(url, evt.target.content.bitmapData);
			var params:ResUnit=_paramsDic[url] as ResUnit;
			if (params.onComplete && params.onComplete.length > 0)
				_delayList.push(url);
		}

		//此处应该有重试机制
		private function onLoaderIOError(evt:IOErrorEvent):void
		{
			removeLoaderEvent(evt.target);
			var url:String=_urlDic[evt.target];
			delete _urlDic[evt.target];
			var params:ResUnit=_paramsDic[url] as ResUnit;
			delete _paramsDic[url];
			delete _loadingDic[url];
			for each (var func:Function in params.onError)
			{
				func(url);
			}
		}

		private function urlLoaderProgressHandler(evt:ProgressEvent):void
		{
			var url:String=_urlDic[evt.target];
			var params:ResUnit=_paramsDic[url] as ResUnit;
			if (params == null)
				return;
			for each (var func:Function in params.onProgress)
			{
				func(URLLoader(evt.target).bytesLoaded, URLLoader(evt.target).bytesTotal);
			}
		}

		private function urlLoaderIOErrorHandler(evt:IOErrorEvent):void
		{
			removeLoaderEvent(evt.target);
			var url:String=_urlDic[evt.target];
			delete _urlDic[evt.target];
			var params:Object=_paramsDic[url];
			delete _loaderDic[url];
			if (++params.errorTimes < ERROR_TIMES)
			{
				_httpUrlList.unshift(url);
			}
			else
			{
				for each (var func:Function in params.onError)
				{
					func(url);
				}
				delete _loadingDic[url];
				delete _paramsDic[url]; //重试次数超过预期时需不需要删除此数据？
			}
			_curLoaderCount--;
			sendHTTPwebRequest();
		}

		private function urlLoaderHTTPStatusHandler(evt:HTTPStatusEvent):void
		{
			if (evt.status == 404)
			{
				removeLoaderEvent(evt.target);
				var url:String=_urlDic[evt.target];
				delete _urlDic[evt.target];
				var params:Object=_paramsDic[url];
				delete _loaderDic[url];
				if (++params.errorTimes < ERROR_TIMES)
				{
					_httpUrlList.unshift(url);
				}
				else
				{
					for each (var func:Function in params.onError)
					{
						func(url);
					}
					delete _loadingDic[url];
					delete _paramsDic[url]; //重试次数超过预期时需不需要删除此数据？
				}
				_curLoaderCount--;
				sendHTTPwebRequest();
			}
		}

		private function delayHandler():void
		{
			if (_delayList.length < 1)
				return;
			var url:String=_delayList.pop();
			var params:ResUnit=_paramsDic[url] as ResUnit;
			_paramsDic[url]=null;
			delete _paramsDic[url];
			delete _loadingDic[url];
			if (params)
			{
				for each (var func:Function in params.onComplete)
				{
					func(url);
				}
			}
		}

		private function removeLoaderEvent(target:Object):void
		{
			if (target is LoaderInfo)
			{
				target.removeEventListener(Event.COMPLETE, onCompleteHandler);
				target.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			}
			else if (target is URLLoader)
			{
				target.removeEventListener(Event.COMPLETE, urlLoaderCompelteHandler);
				target.removeEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
				target.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
				target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, urlLoaderHTTPStatusHandler);
			}
		}

		private function addLoaderEvent(target:Object):void
		{
			if (target is LoaderInfo)
			{
				target.addEventListener(Event.COMPLETE, onCompleteHandler);
				target.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			}
			else if (target is URLLoader)
			{
				target.addEventListener(Event.COMPLETE, urlLoaderCompelteHandler);
				target.addEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
				target.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
				target.addEventListener(HTTPStatusEvent.HTTP_STATUS, urlLoaderHTTPStatusHandler);
			}
		}

		public function clearNotify(url:String, notify:Function):void
		{
			if (isLoading(url))
			{
				var ary:Vector.<Function>=_paramsDic[url].onComplete;
				var index:int=ary.indexOf(notify);
				if (index > -1)
				{
					ary.splice(index, 1);
				}
				else
				{
					ary=_paramsDic[url].onError;
					index=ary.indexOf(notify);
					if (index > -1)
					{
						ary.splice(index, 1);
					}
					else
					{
						ary=_paramsDic[url].onProgress;
						index=ary.indexOf(notify);
						if (index > -1)
							ary.splice(index, 1);
					}
				}
			}
		}

		/**
		 * 取消资源下载
		 */
		public function cancelRes(url:String, gc:Boolean=false):void
		{
			var loader:Object;
			if (isLoading(url))
			{
				for (loader in _urlDic)
				{
					if (_urlDic[loader] == url)
					{
						removeLoaderEvent(loader);
						_urlDic[loader]=null;
						_paramsDic[url]=null;
						_loadingDic[url]=null;
						delete _urlDic[loader];
						delete _paramsDic[url];
						delete _loadingDic[url];
						_curLoaderCount--;
						sendHTTPwebRequest();
						break;
					}
				}
			}
		}

		/**
		 * 取url下的图片，或者url域中link的图片
		 */
		public function getLoadedBitmapData(url:String, link:String=null):BitmapData
		{
			var bmd:BitmapData=ResBMD.instance.getBmd(url, link);
			if (bmd)
				return bmd;
			var cls:Class=getDefClass(url, link);
			if (cls != null)
			{
				bmd=new cls();
				ResBMD.instance.saveLinkBmd(url, link, bmd);
			}
			return bmd;
		}

		/**
		 * 取url下资源，或者url域中link的实例
		 */
		public function getLoadedInstance(url:String, link:String=null):Object
		{
			if (link == null)
				return _loaderDic[url] ? _loaderDic[url].content : null;
			var cls:Class=getDefClass(url, link);
			if (cls != null)
			{
				var s:Object=new cls();
				if (!(s is MovieClip) || (s is MovieClip && MovieClip(s).totalFrames < 2))
				{
					DisplayObject(s).cacheAsBitmap=true;
				}
				return s;
			}
			return null;
		}

		/**
		 * 取url文件所在域
		 */
		public function getDomain(url:String):ApplicationDomain
		{
			var loader:Loader=_loaderDic[url];
			if (loader)
				return ApplicationDomain(loader.contentLoaderInfo.applicationDomain);
			return null;
		}

		public function getDefClass(url:String=null, link:String=null):Class
		{
			var domain:ApplicationDomain=url ? getDomain(url) : ApplicationDomain.currentDomain;
			if (domain && domain.hasDefinition(link))
				return domain.getDefinition(link) as Class;
			return null;
		}

		/**
		 * 清除所有资源域,里面有角色的,也有UI等图片的,此方法慎用
		 * */
		public function clearRes():void
		{
			var url:String;
			for (url in _loadingDic)
			{
				disposeRes(url);
			}
			for (url in _loaderDic)
			{
				disposeRes(url);
			}
		}

		public function disposeRes(url:String, gc:Boolean=false):void
		{
			var loader:*;
			if (isLoading(url))
			{
				for (loader in _urlDic)
				{
					if (_urlDic[loader] == url)
					{
						removeLoaderEvent(loader);
						_urlDic[loader]=null;
						_paramsDic[url]=null;
						_loadingDic[url]=null;
						delete _urlDic[loader];
						delete _paramsDic[url];
						delete _loadingDic[url];
						_curLoaderCount--;
//						sendHTTPwebRequest();
//						break;
					}
				}
			}
			else if (isLoaded(url))
			{
				loader=_loaderDic[url];
				if (loader is Loader)
					loader.unloadAndStop(gc);
				_loaderDic[url]=null;
				ResBMD.instance.delBmd(url);
				delete _loaderDic[url];
			}
		}
	}
}
