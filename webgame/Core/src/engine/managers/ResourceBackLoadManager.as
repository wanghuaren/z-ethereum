package engine.managers
{
	import engine.load.Loadres;
	import engine.utils.compress.ZLIB;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ResourceBackLoadManager
	{
		private static var _instance:ResourceBackLoadManager=null;
		private var _inLoading:Boolean=false;
		private var loaders:Vector.<URLLoader>=null;
		private var _resourceCache:Dictionary=new Dictionary(true);
		private var _loadList:Array=[];
		private var _requestUrlList:Array=[];
		/**
		 * 当前正在加载的url
		 */
		private var _currentLoadUrl:String=null;

		private var names:String;

		public static var info3_suffix:String=".amd";

		public function ResourceBackLoadManager()
		{

		}

		public static function getInstance():ResourceBackLoadManager
		{
			if (_instance == null)
			{
				_instance=new ResourceBackLoadManager();
			}
			return _instance;
		}

		public function get inLoading():Boolean
		{
			return this._inLoading;
		}

		/**
		 * 后台资源下载
		 * @param loadCount 线程数量 默认为1
		 */
		public function init(loadCount:int=1):void
		{
			loaders=new Vector.<URLLoader>();
			for (var i:int=0; i < loadCount; i++)
			{
				var ld:URLLoader=new URLLoader();
				ld.dataFormat=URLLoaderDataFormat.BINARY;
				ld.addEventListener(Event.COMPLETE, loadComplete);
				ld.addEventListener(IOErrorEvent.IO_ERROR, loadIOERROR);
//				ld.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
//				ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
				loaders.push(ld);
			}
			if (this._inLoading == false)
			{
				this.start();
			}
		}

		private function loadIOERROR(e:IOErrorEvent):void
		{
			var loader:URLLoader=e.target as URLLoader;
			names=getFileName(_currentLoadUrl);
			trace("read file failed：" + _currentLoadUrl, names);
			Complete();
		}

		private function loadComplete(e:Event):void
		{
			var loader:URLLoader=e.target as URLLoader;

			var bytes:ByteArray=loader.data as ByteArray;
			//---Warren----Other类去掉了?----------
			names=getFileName(_currentLoadUrl);
			if (names.lastIndexOf("xml") > 0)
			{
				return;
			}
			//--------------------------
			bytes.position=0;
			if (bytes.bytesAvailable > 0)
			{
				var temp:ByteArray=new ByteArray();
				temp.writeBytes(bytes);
				temp.position=0;
				if (temp.readInt() == 2222 && temp.readInt() == 7777)
				{
					temp.readBytes(temp);
					temp.position=0;
					temp.uncompress();
					bytes=temp.readObject() as ByteArray;
				}
				bytes.position=0;
				bytes.position=bytes.length - 8;
				var datalen:int=bytes.readInt();
				var dataend:int=bytes.readInt();
				if (dataend == 8888)
				{
					bytes.position=bytes.length - datalen - 8 + 1;
					var Code:String=bytes.readMultiByte(datalen, "utf-8");
					var Barr:Array=Code.split("ABA5I5");
					if (Barr.length == 2)
					{
						bytes=new ByteArray();
						bytes=ZLIB.uncompress(Barr[1]) as ByteArray;
					}
				}
				bytes.position=0;
				var op:int=0;
				var ll:int=2010;
				if (bytes.readInt() == ll)
				{
					op=bytes.position;
					if (bytes.readInt() == ll + 201)
					{
						ll=bytes.readInt();
					}
					else
					{
						bytes.position=0;
						ll=bytes.readInt();
					}
					var byte:ByteArray=new ByteArray();
					bytes.readBytes(byte, 0, bytes.bytesAvailable);

					var byteLen:int=byte.length;
					for (var ii:int=0; ii < byteLen; ii++)
						byte[ii]=byte[ii] ^ ll;
					bytes=byte;
				}

				// ld = new Loader();
				var ld:Loader=new Loader();
				// andy game_index2-6加载

				var lc:LoaderContext;

				if (Loadres.resAPP["game_index"] != null)
				{
					lc=new LoaderContext();
					lc.applicationDomain=Loadres.resAPP["game_index"];
					ld.loadBytes(bytes, lc);
				}
				else
				{
					ld.loadBytes(bytes);
				}
				ld.contentLoaderInfo.addEventListener(Event.COMPLETE, Complete);
				ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IO_ERROR);

//				ld.addEventListener(Event.COMPLETE, Complete);
//				ld.addEventListener(IOErrorEvent.IO_ERROR, IO_ERROR);
			}
			else
			{
				//Debug.instance.traceMsg("加载失败读取字节流为空!", loadurl[n]);
				trace("load failed byte stream null!");
				Complete();
			}
		}

		private function IO_ERROR(event:IOErrorEvent):void
		{
			trace("IO_ERROR");
		}

		private function Complete(e:Event=null):void
		{
			if (e != null)
			{
				var ld:Loader=(e.target as LoaderInfo).loader;
				Loadres.resSWF[names]=ld;

					//trace("complte",names);

//				if (info0_b == false)
//				{
//					resAPP[names]=ld.contentLoaderInfo.applicationDomain;
//					
//				}
//				else if (second == false)
//				{
//					resAPP[names]=ld.contentLoaderInfo.applicationDomain;
//				}
//				else if (third == false)
//				{
//					resAPP[names]=ld.contentLoaderInfo.applicationDomain;
//				}
//				else if (four == false)
//				{
//					resAPP[names]=ld.contentLoaderInfo.applicationDomain;
//				}

			}
			else
			{
				Loadres.resSWF[names]=Loadres.resSWF[names] == null ? null : Loadres.resSWF[names];
				Loadres.resAPP[names]=Loadres.resAPP[names] == null ? Loadres.nullApplication : Loadres.resAPP[names];
			}
			trace("backLoadComplete-------", _currentLoadUrl, names);
			_currentLoadUrl=null;
			this.loadNext();
		}

		private function onComplete(e:Event):void
		{
			var loadInfo:LoaderInfo=e.target as LoaderInfo;
			_resourceCache[loadInfo.url]=loadInfo.applicationDomain;
			trace("backLoadComplete-------", _currentLoadUrl);
			_currentLoadUrl=null;
//			this.loadNext(loadInfo.loader);
		}

		private function onIOError(e:IOErrorEvent):void
		{
//			var loadInfo:LoaderInfo = e.target as LoaderInfo;
//			this.loadNext(loadInfo.loader);
		}

		public function loadNext(ul:URLLoader=null):void
		{
			return;
			if (_loadList.length > 0)
			{
				_inLoading=true;
				var url:String=_loadList.shift();
				_currentLoadUrl=url;
				var l:URLLoader=this.loaders[0];
				l.load(new URLRequest(url));
			}
			else
			{
				this._inLoading=false;
			}
		}

		/**
		 * 下载资源
		 */
		public function loadResource(url:String):void
		{
			//屏蔽预加载功能  此功能还是有用的，不做删除处理
			trace("DEL:" + url)
			return;
			if (hasRequest(url))
				return;
			this._loadList.push(url);
			if (this.loaders == null)
			{
				this.init();
				return;
			}
			if (this._inLoading == false)
			{
				this.start();
			}
		}

		/**
		 * 是否已经请求资源下载
		 * @param url 资源url
		 */
		public function hasRequest(url:String):Boolean
		{
			if (this._requestUrlList.indexOf(url) == -1)
			{
				this._requestUrlList.push(url);
				return false;
			}
			return true;
		}

		/**
		 * 清除资源请求
		 */
		public function removeRequest(url:String):void
		{
			var index:int=this._requestUrlList.indexOf(url);
			if (index != -1)
			{
				this._requestUrlList.slice(index, 1);
			}
		}

		/**
		 * 启动下载
		 */
		private function start():void
		{
			var l:URLLoader=this.loaders[0];
			this.loadNext(l);
		}

		/**
		 * 资源是否已经缓存
		 */
		public function isCached(url:String):ApplicationDomain
		{
			return _resourceCache[url];
		}

		public static function getFileName(names:String):String
		{
			var Recv:String=null;
			try
			{
				names=names.split("\n").join("");
				var na:int=names.lastIndexOf("/");
				na=na == -1 ? 0 : na + 1;
				names=names.substr(na, names.length);
				Recv=names.substr(0, names.lastIndexOf("."));
			}
			catch (e:Error)
			{
				Recv=null;
			}
			return Recv;
		}

		public static function getFileVer(names:String):String
		{
			var Recv:String=null;
			try
			{
				names=names.split("\n").join("");
				var na:int=names.lastIndexOf("?ver=");
				na=na == -1 ? 0 : na + 5;
				names=names.substr(na, names.length);
				Recv=names;
			}
			catch (e:Error)
			{
				Recv=null;
			}
			return Recv;
		}

	}
}
