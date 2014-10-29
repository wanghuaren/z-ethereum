package com.bellaxu.res
{
    import com.bellaxu.debug.Debug;
    import com.bellaxu.mgr.TimerMgr;
    import com.bellaxu.model.lib.Lib;
    import com.bellaxu.res.pool.LoaderPool;
    import com.bellaxu.res.pool.URLLoaderPool;
    import com.bellaxu.util.AmdUtil;
    import com.bellaxu.util.PathUtil;
    
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
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
    
    /**
     * 资源统一加载
     * @author by BellaXu
     */
    public final class ResLoader
    {
		private static const THREAD_NUM:uint = 10;
		private static const ERROR_TIMES:uint = 3;
        private static var _instance:ResLoader;
        private var _urlDic:Dictionary;
        private var _loaderDic:Dictionary;
        private var _loadingDic:Dictionary;
        private var _paramsDic:Dictionary;
        private var _httpUrlList:Array;
        private var _curLoaderCount:int;
		private var _delayList:Vector.<String>; //延时通知加载完的更新，只处理mc和位图资源

        public function ResLoader()
        {
			URLLoaderPool.init();
			LoaderPool.init();
            _urlDic = new Dictionary();
            _loadingDic = new Dictionary();
            _loaderDic = new Dictionary();
            _paramsDic = new Dictionary();
            _httpUrlList = [];
			_delayList = new <String>[];
			TimerMgr.getInstance().add(33, delayHandler);
        }

        public static function getInstance():ResLoader
        {
            if (_instance == null)
                _instance = new ResLoader();
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
        public function loadRes(url:String, onComplete:Function = null, onProgress:Function = null, onError:Function = null, domain:ApplicationDomain = null, priority:uint = 0, format:String = URLLoaderDataFormat.BINARY, ver:String = null):void
        {
            if (!url)
                return;
            if (isLoading(url))
            {
                if (onComplete != null && _paramsDic[url].onComplete.indexOf(onComplete) < 0)
                    _paramsDic[url].onComplete.push(onComplete);
                if (onProgress != null && _paramsDic[url].onProgress.indexOf(onProgress) < 0)
                    _paramsDic[url].onProgress.push(onProgress);
                if (onError != null && _paramsDic[url].onError.indexOf(onError) < 0)
                    _paramsDic[url].onError.push(onError);
                return;
            }
			_loadingDic[url] = true;
            if (_loaderDic[url])
            {
                if (onProgress != null)
                    onProgress(100, 100);
				if (onComplete != null)
				{
					if(!_paramsDic[url])
						_paramsDic[url] = {onComplete:[], onProgress:[], onError:[]};
					if(_paramsDic[url].onComplete.indexOf(onComplete) < 0)
						_paramsDic[url].onComplete.push(onComplete);
				}
				if(_delayList.indexOf(url) < 0)
					_delayList.push(url);
                return;
            }
            //插队优化
			var i:int = 0;
			for (i = 0; i < _httpUrlList.length; i++)
			{
				var params:Object = _paramsDic[_httpUrlList[i]];
				if (params.priority <= priority)
				{
					_httpUrlList.splice(i, 0, url);
					break;
				}
			}
			if(i >= _httpUrlList.length)
				_httpUrlList.push(url);
            _paramsDic[url] = {
                    onComplete: onComplete != null ? [onComplete] : [], 
                    onError: onError != null ? [onError] : [], 
                    onProgress: onProgress != null ? [onProgress] : [], 
                    errorTimes: 0,
					domain: domain,
					priority: priority, 
					format: format,
					ver: ver
                };
            sendHTTPwebRequest();
        }

        private function sendHTTPwebRequest():void
        {
            if (_curLoaderCount >= THREAD_NUM || _httpUrlList.length < 1)
                return;
            var url:String = _httpUrlList.shift();
            var urlLoader:URLLoader = URLLoaderPool.pop();
            _urlDic[urlLoader] = url;
            _curLoaderCount++;
            urlLoader.dataFormat = _paramsDic[url].format;
            urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompelteHandler);
            urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            urlLoader.load(new URLRequest(PathUtil.getFullPath(url) + "?ver=" + (_paramsDic[url].ver ? _paramsDic[url].ver : ResTime.getTime(url))));
        }

        private function urlLoaderCompelteHandler(evt:Event):void
        {
			evt.target.removeEventListener(Event.COMPLETE, urlLoaderCompelteHandler);
			evt.target.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			evt.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			evt.target.close();
			URLLoaderPool.recycle(evt.target as URLLoader);
			//正在加载数减1，继续加载下一个
            _curLoaderCount--;
            sendHTTPwebRequest();
            var url:String = _urlDic[evt.target];
			_urlDic[evt.target] = null;
			delete _urlDic[evt.target];
			var params:Object = _paramsDic[url];
			if(params.format == URLLoaderDataFormat.TEXT)
			{
				ResXml.saveTxtXml(url, evt.target.data);
				delete _paramsDic[url];
				delete _loadingDic[url];
				_loaderDic[url] = true;
				for each (func in params.onComplete)
				{
					func(url);
				}
				return;
			}
            var bytes:ByteArray = evt.target.data as ByteArray;
			var func:Function = null;
			switch(url.substr(-3, 3))
			{
				case "txt"://txt
				case "xml"://xml文件
					ResXml.saveXMLByBytes(url, bytes);
					delete _paramsDic[url];
					delete _loadingDic[url];
					_loaderDic[url] = true;
					for each (func in params.onComplete)
					{
						func(url);
					}
					break;
				case "dat"://二进制“键－值”数据
					ResDat.saveDatByBytes(url, bytes);
					delete _paramsDic[url];
					delete _loadingDic[url];
					_loaderDic[url] = true;
					for each (func in params.onComplete)
					{
						func(url);
					}
					break;
				case "lib"://工具生成的游戏配置(原lib.swf)
					Lib.save(bytes);
					delete _paramsDic[url];
					delete _loadingDic[url];
					_loaderDic[url] = true;
					for each (func in params.onComplete)
					{
						func(url);
					}
					break;
				case "amd"://加过密的swf
					bytes = AmdUtil.decodeBytes(bytes);
				case "swf"://swf
				default:
					var loader:Loader = LoaderPool.pop();
					_urlDic[loader.contentLoaderInfo] = url;
					_loaderDic[url] = loader;
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
					var lc:LoaderContext = new LoaderContext();
					lc.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
					lc.applicationDomain = params.domain ? params.domain : new ApplicationDomain();
					loader.loadBytes(bytes);
					break;
			}
        }

        private function onProgressHandler(evt:ProgressEvent):void
        {
            var url:String = _urlDic[evt.target];
            var params:Object = _paramsDic[url];
            for each (var func:Function in params.onProgress)
            {
                func(URLLoader(evt.target).bytesLoaded, URLLoader(evt.target).bytesTotal);
            }
        }

        private function onCompleteHandler(evt:Event):void
        {
			removeLoaderEvent(evt.target);
            var url:String = _urlDic[evt.target];
			delete _urlDic[evt.target];
			//存储位图
			if(url.substr(-2, 2) == "ng" || url.substr(-2, 2) == "pg")
				ResBmd.saveBmd(url, evt.target.content.bitmapData);
            var params:Object = _paramsDic[url];
			if(params.onComplete && params.onComplete.length > 0)
				_delayList.push(url);
//            for each (var func:Function in params.onComplete)
//            {
//                func(url);
//            }
        }
		
		private function delayHandler():void
		{
			if(!_delayList.length)
				return;
			var url:String = _delayList.pop();
			var params:Object = _paramsDic[url];
			_paramsDic[url] = null;
			delete _paramsDic[url];
			delete _loadingDic[url];
			for each(var func:Function in params.onComplete)
			{
				func(url);
			}
		}
		
		private function onLoaderIoError(evt:IOErrorEvent):void
		{
			removeLoaderEvent(evt.target);
			var url:String = _urlDic[evt.target];
			delete _urlDic[evt.target];
			var params:Object = _paramsDic[url];
			delete _paramsDic[url];
			delete _loadingDic[url];
			for each (var func:Function in params.onError)
			{
				func(url);
			}
			Debug.warn("不能处理的资源：" + url);
		}

        private function ioErrorHandler(evt:IOErrorEvent):void
        {
			removeLoaderEvent(evt.target);
            var url:String = _urlDic[evt.target];
			delete _urlDic[evt.target];
            var params:Object = _paramsDic[url];
            delete _loaderDic[url];
			if (++params.errorTimes < ERROR_TIMES)
			{
				_httpUrlList.unshift(url);
			}
			else
			{
				Debug.error("load failed(" + params.errorTimes + "): " + PathUtil.getFullPath(url));
				for each (var func:Function in params.onError)
				{
					func(url);
				}
				//delete _loadingDic[url];
				//delete _paramsDic[url];重试次数超过预期时需不需要删除此数据？
			}
			_curLoaderCount--;
			sendHTTPwebRequest();
        }
		
		private function removeLoaderEvent(target:*):void
		{
			if(target is LoaderInfo)
			{
				target.removeEventListener(Event.COMPLETE, onCompleteHandler);
				target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				//加载完不清，因为有link
				//target.loader.unloadAndStop(true);
			}
			else
			{
				target.removeEventListener(Event.COMPLETE, urlLoaderCompelteHandler);
				target.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				target.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				try
				{
					target.close();
				}
				catch(e:Error)
				{
					
				}
			}
		}

        public function clearNotify(url:String, notify:Function):void
        {
            if (isLoading(url))
            {
                var ary:Array = _paramsDic[url].onComplete;
                var index:int = ary.indexOf(notify);
                if (index > -1)
				{
					ary.splice(index, 1);
				}
				else
				{
					ary = _paramsDic[url].onError;
					index = ary.indexOf(notify);
					if(index > -1)
					{
						ary.splice(index, 1);
					}
					else
					{
						ary =  _paramsDic[url].onProgress;
						index = ary.indexOf(notify);
						if(index > -1)
							ary.splice(index, 1);
					}
				}
            }
        }
		
		/**
		 * 取消资源下载
		 */
		public function cancelRes(url:String, gc:Boolean = true):void
		{
			var loader:*;
			if (isLoading(url))
			{
				for (loader in _urlDic)
				{
					if (_urlDic[loader] == url)
					{
						if (loader is LoaderInfo)
						{
							LoaderInfo(loader).removeEventListener(Event.COMPLETE, onCompleteHandler);
							LoaderInfo(loader).removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
							LoaderInfo(loader).loader.unloadAndStop(gc);
							LoaderPool.recycle(LoaderInfo(loader).loader);
						}
						else if (loader is URLLoader)
						{
							URLLoader(loader).removeEventListener(Event.COMPLETE, urlLoaderCompelteHandler);
							URLLoader(loader).removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
							URLLoader(loader).removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
							URLLoader(loader).close();
							URLLoaderPool.recycle(loader as URLLoader);
						}
						_urlDic[loader] = null;
						_paramsDic[url] = null;
						_loadingDic[url] = null;
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
        public function getLoadedBitmapData(url:String, link:String = null):BitmapData
        {
			var bmd:BitmapData = ResBmd.getBmd(url, link);
			if(bmd)
				return bmd;
			var cls:Class = getDefClass(url, link);
			if(cls != null)
			{
				bmd = new cls(0, 0);
				ResBmd.saveLinkBmd(url, link, bmd);
			}
			return bmd;
        }
		
		/**
		 * 取url下资源，或者url域中link的实例
		 */
		public function getLoadedInstance(url:String, link:String = null):*
		{
			if(!link)
				return _loaderDic[url] ? _loaderDic[url].content : null;
			var cls:Class = getDefClass(url, link);
			if (cls != null)
			{
				var s:* = new cls();
				if (!(s is MovieClip) || (s is MovieClip && MovieClip(s).totalFrames < 2))
				{
					DisplayObject(s).cacheAsBitmap = true;
				}
				return s;
			}
			return null;
		}

		/**
		 * 取url文件所在域
		 */
		public function getDomain(url: String):ApplicationDomain
		{
			var loader:Loader = _loaderDic[url];
			if (loader)
				return ApplicationDomain(loader.contentLoaderInfo.applicationDomain);
			return null;
		}

        public function getDefClass(url:String = null, link:String = null):Class
        {
            var domain:ApplicationDomain = url ? getDomain(url) : ApplicationDomain.currentDomain;
            if (domain && domain.hasDefinition(link))
                return domain.getDefinition(link) as Class;
            return null;
        }
		public function clearRes():void
		{
			var url:String;
			for(url in _loadingDic)
			{
				disposeRes(url);
			}
			for(url in _loaderDic)
			{
				disposeRes(url);
			}
//			ResMcMgr.clean();
		}
		
		public function disposeRes(url:String, gc:Boolean = true):void
		{
			var loader:*;
			if (isLoading(url))
			{
				for (loader in _urlDic)
				{
					if (_urlDic[loader] == url)
					{
						if (loader is LoaderInfo)
						{
							LoaderInfo(loader).removeEventListener(Event.COMPLETE, onCompleteHandler);
							LoaderInfo(loader).removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
							LoaderInfo(loader).loader.unloadAndStop(gc);
							LoaderPool.recycle(LoaderInfo(loader).loader);
						}
						else if (loader is URLLoader)
						{
							URLLoader(loader).removeEventListener(Event.COMPLETE, urlLoaderCompelteHandler);
							URLLoader(loader).removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
							URLLoader(loader).removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
							URLLoader(loader).close();
							URLLoaderPool.recycle(loader as URLLoader);
						}
						_urlDic[loader] = null;
						_paramsDic[url] = null;
						_loadingDic[url] = null;
						
						delete _urlDic[loader];
						delete _paramsDic[url];
						delete _loadingDic[url];
						_curLoaderCount--;
						sendHTTPwebRequest();
						break;
					}
				}
			}
			else if(isLoaded(url))
			{
				loader = _loaderDic[url];
				if(loader is Loader)
					loader.unloadAndStop(gc);
				_loaderDic[url] = null;
				delete _loaderDic[url];
			}
		}
    }
}
