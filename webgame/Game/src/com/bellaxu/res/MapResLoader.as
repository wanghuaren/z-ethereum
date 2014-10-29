package com.bellaxu.res
{
	import com.bellaxu.debug.Debug;
	import com.bellaxu.mgr.TimerMgr;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.res.pool.LoaderPool;
	import com.bellaxu.res.pool.URLLoaderPool;
	import com.bellaxu.util.AmdUtil;
	import com.bellaxu.util.MathUtil;
	import com.bellaxu.util.PathUtil;
	
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

	public class MapResLoader
	{
		private static const THREAD_NUM:uint=9;
		private static const ERROR_TIMES:uint=3;
		private static var _instance:MapResLoader;
		private var _mapDic:Dictionary;
		private var _urlDic:Dictionary;
		private var _loadingDic:Dictionary;
		private var _paramsDic:Dictionary;
		private var _httpUrlList:Array;
		private var _curLoaderCount:int;
		private var _delayList:Vector.<String>; //延时通知加载完的更新，只处理mc和位图资源

		public function MapResLoader()
		{
			URLLoaderPool.init();
			LoaderPool.init();
			_mapDic=new Dictionary();
			_urlDic=new Dictionary();
			_loadingDic=new Dictionary();
			_paramsDic=new Dictionary();
			_httpUrlList=[];
			_delayList=new <String>[];
			TimerMgr.getInstance().add(33, delayHandler);
		}

		public static function getInstance():MapResLoader
		{
			if (_instance == null)
				_instance=new MapResLoader();
			return _instance;
		}

		public function isLoading(url:String):Boolean
		{
			return _loadingDic[url];
		}

		public function isLoaded(url:String):Boolean
		{
			return _mapDic[url] != undefined && _mapDic[url] != null;
		}

		/**
		 * @param url : 资源相对路径
		 * @param completeFunc : 带url参数的回调方法(normal)，若为dat，同时带byte
		 */
		public function loadRes(url:String, onComplete:Function=null, ver:String=null):void
		{
			if (!url)
				return;
			if (isLoading(url))
			{
				if (onComplete != null && _paramsDic[url].onComplete.indexOf(onComplete) < 0)
					_paramsDic[url].onComplete.push(onComplete);
				return;
			}
			_loadingDic[url]=true;
			if (isLoaded(url))
			{
				if (onComplete != null)
				{
					if (!_paramsDic[url])
						_paramsDic[url]={onComplete: []};
					if (_paramsDic[url].onComplete.indexOf(onComplete) < 0)
						_paramsDic[url].onComplete.push(onComplete);
				}
				if (_delayList.indexOf(url) < 0)
					_delayList.push(url);
				return;
			}
			_httpUrlList.unshift(url);
			_paramsDic[url]={onComplete: onComplete != null ? [onComplete] : [], errorTimes: 0, ver: ver, isLoaded: false};
			sendHTTPwebRequest();
		}

		private function sendHTTPwebRequest():void
		{
			if (_curLoaderCount >= THREAD_NUM || _httpUrlList.length < 1)
				return;
			var url:String=_httpUrlList.shift();
			var loader:Loader=LoaderPool.pop();
			_urlDic[loader.contentLoaderInfo]=url;
			_curLoaderCount++;

			var lc:LoaderContext=new LoaderContext();
			lc.allowCodeImport=true;
			lc.imageDecodingPolicy=ImageDecodingPolicy.ON_LOAD;
			lc.applicationDomain=new ApplicationDomain();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			loader.load(new URLRequest(PathUtil.getFullPath(url) + "?ver=" + _paramsDic[url].ver),lc);
		}

		private function onCompleteHandler(evt:Event):void
		{
			evt.target.removeEventListener(Event.COMPLETE, onCompleteHandler);
			evt.target.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			evt.target.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
			evt.target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);

			var url:String=_urlDic[evt.target];
//			delete _urlDic[evt.target];
			var params:Object=_paramsDic[url];

			if (params.isLoaded)
			{
				_mapDic[url]=evt.target.content.bitmapData;

				if (params.onComplete && params.onComplete.length > 0)
					_delayList.push(url);
			}
			else
			{
				params.ver=MathUtil.getRandomInt(10000, 99999);
				_httpUrlList.push(url);
			}
			_curLoaderCount--;
			sendHTTPwebRequest();
		}

		private function delayHandler():void
		{
			if (!_delayList.length)
				return;
			var url:String=_delayList.pop();
			var params:Object=_paramsDic[url];
			delete _paramsDic[url];
			delete _loadingDic[url];
			if (params != null)
			{
				for each (var func:Function in params.onComplete)
				{
					func(url);
				}
			}
		}

		private function onProgressHandler(evt:ProgressEvent):void
		{
			var url:String=_urlDic[evt.target];
			_paramsDic[url].isLoaded=(evt.bytesLoaded == evt.bytesTotal);
		}
		private function onStatus(e:HTTPStatusEvent):void
		{
			if (e.status == 404 || e.status == 0)
			{
				onLoaderIoError(null,e.target)
			}
		}
		private function onLoaderIoError(evt:IOErrorEvent,mTarget:Object=null):void
		{
			if(evt!=null){
				mTarget=evt.target;
			}
			mTarget.removeEventListener(Event.COMPLETE, onCompleteHandler);
			mTarget.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			mTarget.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
			mTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);

			var url:String=_urlDic[mTarget];
			delete _urlDic[mTarget];
			delete _loadingDic[url];

			if (++_paramsDic[url].errorTimes < ERROR_TIMES)
			{
				_httpUrlList.push(url);
			}
			else
			{
				Debug.error("load failed(" + _paramsDic[url].errorTimes + "): " + PathUtil.getFullPath(url));
			}
			_curLoaderCount--;
			sendHTTPwebRequest();
		}

		/**
		 * 取url下的图片，或者url域中link的图片
		 */
		public function getMapBmd(url:String):BitmapData
		{
			return _mapDic[url];
		}

		/**
		 * 取消资源下载
		 */
		public function cancelRes(url:String, gc:Boolean=true):void
		{
			var loader:*;
			if (isLoading(url))
			{
				for (loader in _urlDic)
				{
					if (_urlDic[loader] == url)
					{
						_urlDic[loader] = null;
						_paramsDic[url] = null;
						_loadingDic[url] = null;
						delete _urlDic[loader];
						delete _paramsDic[url];
						delete _loadingDic[url];
						
						if (loader is LoaderInfo)
						{
							LoaderInfo(loader).removeEventListener(Event.COMPLETE, onCompleteHandler);
							LoaderInfo(loader).removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
							LoaderInfo(loader).removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
							LoaderInfo(loader).removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
							LoaderInfo(loader).loader.unloadAndStop(gc);
							LoaderPool.recycle(LoaderInfo(loader).loader);
						}
						_curLoaderCount--;
						sendHTTPwebRequest();
						break;
					}
				}
			}
			else if(isLoaded(url))
			{
//				var bmd:BitmapData=_mapDic[url];
//				if (bmd)
//				{
//					bmd.dispose();
//					bmd=null;
//				}
//				_mapDic[url]=null;
//				delete _mapDic[url];
//				loader = _urlDic[url];
//				if(loader is Loader)
//					loader.unloadAndStop(gc);
//				_urlDic[url] = null;
//				delete _urlDic[url];
			}
		}

		public function clearMapRes():void
		{
			_delayList.length = 0;
			_httpUrlList.length = 0;
			var url:String;
			var info:*;
			var bmd:BitmapData;
			for (url in _mapDic)
			{
				bmd=_mapDic[url];
				if (bmd)
				{
					bmd.dispose();
					bmd=null;
				}
				_mapDic[url]=null;
				delete _mapDic[url];
			}
			for (info in _urlDic)
			{
				if (info)
				{
					LoaderInfo(info).removeEventListener(Event.COMPLETE, onCompleteHandler);
					LoaderInfo(info).removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
					LoaderInfo(info).removeEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
					LoaderInfo(info).removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
					url = _urlDic[info];
					_urlDic[info] = null;
					_paramsDic[url] = null;
					_loadingDic[url] = null;
					delete _urlDic[info];
					delete _paramsDic[url];
					delete _loadingDic[url];
					LoaderInfo(info).loader.unloadAndStop(true);
				}
			}
//			_mapDic=new Dictionary();
			_curLoaderCount=0;
		}
	}
}
