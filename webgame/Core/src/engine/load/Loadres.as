package engine.load
{

	import engine.event.DispatchEvent;
	import engine.managers.ResourceBackLoadManager;
	import engine.utils.Hash;
	import engine.utils.SystemGC;
	import engine.utils.compress.ZLIB;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	// fux
	// 如果只是派发事件，继承EventDispatcher更轻量
	// 生成一个MC是很大的开销
	public class Loadres extends EventDispatcher
	{
		// =============================================
		private var n:int;
		// private var loader:URLLoader;
		private var loadurl:Array=[];
		private var TotalLoadeded:int;
		// private var ld:Loader;
		private var names:String;
		// =============================================
		private static var _resSWF:Dictionary=new Dictionary(true);
		private static var _resAPP:Dictionary=new Dictionary(true);

		/**
		 * 创建角色界面显示前需要加载的
		 */
		public static var info0:Array=new Array();

		public static var info1:Array=new Array();
		/**
		 * 进入游戏后加载列表，点那个会调整顺序
		 * 提升顺序至下一个
		 */
		public static var info2:Array=new Array();

		/**
		 * 不会自动加载
		 * 点哪个加载哪个
		 */
		//public static var info3:Array=new Array();

		public static var info3_suffix:String=".amd";

		private var _currUrl:String=null;


		public static function set resSWF(value:Dictionary):void
		{
			_resSWF=value;
		}

		public static function set resAPP(value:Dictionary):void
		{
			_resAPP=value;
		}

		public static function get resSWF():Dictionary
		{
//			trace("A")
//			showDIC(_resSWF)
			return _resSWF;
		}

		public static function get resAPP():Dictionary
		{
//			showDIC(_resAPP)
			return _resAPP;
		}

		public static function showDIC(value:Dictionary):void
		{
			trace("###########################")
			for (var key:* in value)
			{
				if (!(value[key] as XML))
				{

					trace(key + ":" + value[key]);
				}
			}
			trace("###########################")
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

		// =============================================
		public function Loadres():void
		{

			// Debug.instance.traceMsg("Loadres");
		}
		private static var _instance:Loadres;

		public static function getInstance():Loadres
		{
			if (_instance == null)
			{
				_instance=new Loadres();
			}
			return _instance;
		}
		public static var vectorPoolItems:Vector.<Loadres>=new Vector.<Loadres>();

		public function get getItem():Loadres
		{
			var currItem:Loadres;
			if (vectorPoolItems.length > 100)
			{
				currItem=Loadres.vectorPoolItems.shift();
			}
			else
			{
				currItem=new Loadres();
			}
			if(vectorPoolItems.indexOf(currItem)!=-1)Loadres.vectorPoolItems.push(currItem);
			return currItem;
		}

		/**
		 * 与SkinPool同，在切换地图时清理
		 */
		public static function clear2(libName:String):void
		{

			//使用频率高的不删除

			//杀怪物得到的魂点
			if ("hun_ball" == libName)
			{
				return;
			}

			//法师基本技能
			//这个在屏幕上时间短，可重复利用
			if ("skill_400039" == libName)
			{
				return;
			}

			//修炼基本特效
			//修炼的人太多，几十个人，快100多人,占用内存太多，
			//if("xllevel1" == libName)
			//{
			//	return;
			//}

			//魂技能基本特效
			//if("hunlevel1" == libName)
			//{
			//	return;
			//}

			//阵法
			//if("team_light1" == libName)
			//{
			//	return;
			//}

			//路点
			if ("sys_800001" == libName)
			{
				return;
			}

			//
			var ld:Loader;
			var keyStr:String;

			for (var key:Object in resSWF)
			{
				keyStr=key.toString();

				//删
				if (keyStr.indexOf(libName) == 0)
				{
					//Debug.instance.traceMsg("unload key:" + key);

					//MsgPrint.printTrace("unload key:" + key,MsgPrintType.WINDOW_REFRESH);

					trace("unload key:" + key);

					//
					delete resAPP[key];

					//
					ld=(resSWF[key] as Loader);
					ld.unloadAndStop(false);
					ld=null;

					delete resSWF[key];
				}

			}
			SystemGC.gc();
		}

		public static function clear(myking_s0:String, myking_s1:String, myking_s2:String, myking_s3:String, myKing_metier:int, myking_pet_s2:String):void
		{
			//resSWF[names]=ld;
			//resAPP[names]=ld.contentLoaderInfo.applicationDomain;

			var ld:Loader;
			var keyStr:String;
			var myKing_metier_s:String;

			myKing_metier_s="sk000" + myKing_metier.toString();
			myKing_metier_s=myKing_metier_s;

			for (var key:Object in resSWF)
			{
				//只销毁m开头的
				//Debug.instance.traceMsg(key, resSWF[key]);

				//m1 人物
				//m00 怪物
				//p01 宠物
				//3100 采集
				//sk000 技能
				/*String(key).indexOf("3100") > -1 ||
					String(key).indexOf("3200") > -1 ||
					String(key).indexOf("3300") > -1 ||
					String(key).indexOf("r00") > -1 ||
					String(key).indexOf("r01") > -1*/

				//不删自已
				if (null == myking_s0)
				{
					myking_s0="";
				}

				if (null == myking_s1)
				{
					myking_s1="";
				}

				if (null == myking_s2)
				{
					myking_s2="";
				}

				if (null == myking_s3)
				{
					myking_s3="";
				}

				if (null == myking_pet_s2)
				{
					myking_pet_s2="";
				}

				myking_s0=myking_s0;
				myking_s1=myking_s1;
				myking_s2=myking_s2;
				myking_s3=myking_s3;
				myking_pet_s2=myking_pet_s2;

				keyStr=key.toString();

				if (myking_s0.indexOf(keyStr) > -1 || myking_s1.indexOf(keyStr) > -1 || myking_s2.indexOf(keyStr) > -1 || myking_s3.indexOf(keyStr) > -1 || myking_pet_s2.indexOf(keyStr) > -1)

				{
					continue;
				}

				//删除非本职业技能
				if (myKing_metier_s.indexOf(keyStr) > -1)
				{
					continue;
				}

				//删
				if (keyStr.indexOf("m1") > -1 || keyStr.indexOf("m2") > -1 || keyStr.indexOf("m00") > -1 || keyStr.indexOf("p01") > -1 || keyStr.indexOf("sk000") == 0)
				{
					trace("unload key:" + key);
					//
					delete resAPP[key];

					//
					ld=(resSWF[key] as Loader);
					ld.unloadAndStop(false);
					ld=null;

					delete resSWF[key];
				}

			} //end for
			SystemGC.gc();

		}




		public function load(url:Array):void
		{
			if (url == null || url.length <= 0)
				return;
			//fux ""空字符加载会访问相对路径，引起2044，2144错误，未知的文件类型
			var len:int=url.length;
			for (var i:int=0; i < len; i++)
			{
				if ("" == url[i])
				{
					url.splice(i, 1);
					//i=0;
					i=-1;
					len=url.length;
				}

			}
			loadurl=[];
			for each (var loadurlstr:String in url)
			{
				var swfname:String=getFileName(loadurlstr);
				var ad:ApplicationDomain=ResourceBackLoadManager.getInstance().isCached(loadurlstr);
				if (ad != null)
				{
					resAPP[swfname]=ad;
					continue;
				}
				ResourceBackLoadManager.getInstance().removeRequest(loadurlstr);
				if (swfname != null)
				{
					if (resSWF[swfname] == null && loadurlstr.substr(loadurlstr.length - 1, 1) != "/")
					{
						loadurlstr=loadurlstr.split("\n").join("");
						loadurl.push(loadurlstr);
					}
					else
					{
						dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_RES_PROGRESS, {name: swfname, load: resSWF[swfname]}));
					}
				}
			}
			if (loadurl.length > 0)
			{
				TotalLoadeded=0;
				loading(loadurl[0]);
			}
			else
			{
				//dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_COMPLETE, null));
				dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_COMPLETE, this));
			}
		}
		private static var urlHash:Hash=new Hash
		private function loading(url:String):void
		{
			url=url.split("\n").join("");
			url=url.substr(url.lastIndexOf("http://"), url.length);
			// loader=new URLLoader(new URLRequest(url));
			this._currUrl=url;
			if(urlHash.has(url)==false)
			{
				if(url.indexOf('xml')!=-1)
				{
					trace(url)
				}
					urlHash.put(url,url)
					var loader:URLLoader=new URLLoader(new URLRequest(url));
					loader.dataFormat=URLLoaderDataFormat.BINARY;
					loader.addEventListener(ProgressEvent.PROGRESS, loadProgress);
					loader.addEventListener(Event.COMPLETE, loadComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR, loadIOERROR);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			}
		}
		private function httpStatusHandler(e:HTTPStatusEvent):void{
			if(e.status==404||e.status==0){
				loadurl.push(getFileName(loadurl[n]));
			}
		}
		public static function clean2():void
		{
			urlHash.dispose()
			urlHash=new Hash
		}
		
		public static function clean(key:String):void
		{
			
			for (var link:String in urlHash)
			{
				if(link.indexOf(key)!=-1)
				{
					urlHash.remove(link);
				}
			}
			for (var link2:String in resSWF)
			{
				if(link2.indexOf(key)!=-1)
				{
					delete resSWF[link2]
				}
			}
			for (var link3:String in resAPP)
			{
				if(link3.indexOf(key)!=-1)
				{
					delete resAPP[link3]
				}
			}
//			urlHash.dispose()
//			urlHash=new Hash
		}
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_SECURITY_ERROR, ""));
		}

		private function loadIOERROR(e:IOErrorEvent=null):void
		{
			var loader:URLLoader=e.target as URLLoader;
			trace("read file failed：" + loadurl[n]);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, loadIOERROR);
			loader.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader.removeEventListener(Event.COMPLETE, loadComplete);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
//			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_IO_ERROR, "read file failed：" + loadurl[n]));
//			resSWF[getFileName(loadurl[n])]=nullApplication;
			names=getFileName(loadurl[n]);
			Complete();
		}

		private function loadProgress(e:ProgressEvent):void
		{
			var bytesLoaded:Number=e.bytesLoaded;
			var bytesTotal:Number=e.bytesTotal;

			if (isNaN(bytesLoaded) || isNaN(bytesTotal))
			{
				return;
			}

			if (!isFinite(bytesLoaded) || !isFinite(bytesTotal))
			{
				return;
			}

			SendProgress(bytesLoaded / bytesTotal * 100, bytesLoaded, bytesTotal, e.target);

		}
		/**
		 * 有的模型没有初始动作   但流程要从初始动作开始加载 所以加一个空的ApplicationDomain
		 * */
		public static var nullApplication:ApplicationDomain=new ApplicationDomain();

		private function loadComplete(e:Event):void
		{
			var loader:URLLoader=e.target as URLLoader;

			loader.removeEventListener(IOErrorEvent.IO_ERROR, loadIOERROR);
			loader.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
			loader.removeEventListener(Event.COMPLETE, loadComplete);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			var bytes:ByteArray=loader.data as ByteArray;
			//---Warren----Other类去掉了?----------
			names=getFileName(loadurl[n]);
			if (names == null)
				return;
			if (names.lastIndexOf("xml") > 0)
			{
				bytes.position=0;
				resAPP[names]=new XML(bytes.readUTFBytes(bytes.bytesAvailable));
//				resSWF[names.replace("xml", "")]=Loadres.nullApplication;
				dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_RES_PROGRESS, {name: names.replace("xml", ""), load: resAPP[names]}));
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

				if (info0_b == true && resAPP["game_index"] != null)
				{
					lc=new LoaderContext();
					lc.applicationDomain=resAPP["game_index"];
					ld.loadBytes(bytes, lc);

				}
				else if (second == true && resAPP["game_index"] != null)
				{
					lc=new LoaderContext();
					lc.applicationDomain=resAPP["game_index"];
					ld.loadBytes(bytes, lc);
				}
				else if (third == true && resAPP["game_index"] != null)
				{
					lc=new LoaderContext();
					lc.applicationDomain=resAPP["game_index"];
					ld.loadBytes(bytes, lc);
				}
				else if (four == true && resAPP["game_index"] != null)
				{
					lc=new LoaderContext();
					lc.applicationDomain=resAPP["game_index"];
					ld.loadBytes(bytes, lc);
				}
				else
				{
					ld.loadBytes(bytes);
				}
				ld.contentLoaderInfo.addEventListener(Event.COMPLETE, Complete);
				ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IO_ERROR);

				ld.addEventListener(Event.COMPLETE, Complete);
				ld.addEventListener(IOErrorEvent.IO_ERROR, IO_ERROR);
					//names= getFileName(loadurl[n]);

					// fux add
					// debug不出现Event.COMPLETE事件，因此这里暂加上
					// 以便调试能够继续
					// 正式运行，请把这句话注释掉，不然有些怪物的形象会看不见
					// ld.dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				//Debug.instance.traceMsg("加载失败读取字节流为空!", loadurl[n]);
				trace("load failed byte stream null!" + loadurl[n]);
				Complete();
			}
		}

		private function IO_ERROR(event:IOErrorEvent):void
		{
			trace("IO_ERROR");
		}

		public function Complete(e:Event=null):void
		{
			if (e != null)
			{
				var ld:Loader=(e.target as LoaderInfo).loader;
				resSWF[names]=ld;

				//trace("complte",names);

				if (info0_b == false)
				{
					resAPP[names]=ld.contentLoaderInfo.applicationDomain;

				}
				else if (second == false)
				{
					resAPP[names]=ld.contentLoaderInfo.applicationDomain;
				}
				else if (third == false)
				{
					resAPP[names]=ld.contentLoaderInfo.applicationDomain;
				}
				else if (four == false)
				{
					resAPP[names]=ld.contentLoaderInfo.applicationDomain;
				}

				ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, Complete);
				ld.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, IO_ERROR);
				ld.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				ld.removeEventListener(Event.COMPLETE, Complete);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, IO_ERROR);
				ld.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_RES_PROGRESS, {name: names, load: resSWF[names]}));
			}
			else
			{
				resSWF[names]=resSWF[names] == null ? null : resSWF[names];
				resAPP[names]=resAPP[names] == null ? nullApplication : resAPP[names];
			}
			if (n < loadurl.length - 1)
			{
				n+=1;
				var Fnames:String=getFileName(loadurl[n]);
				if (resSWF[Fnames] == undefined || resSWF[Fnames] == null)
				{
					loading(loadurl[n]);
				}
				else
				{
					SendProgress(100);
					Complete();
				}
			}
			else
			{
				// game_index加载完成
				if (second == true && _currUrl.indexOf("game_index") >= 0)
				{
					second=false;
					Loadres.second_complete=true;
					trace("load complete:" + _currUrl);
				}

				// andy game_index2-6加载完成
				if (third == true )
				{
					//third=false;
					third_complete=true;
				}
				//dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_COMPLETE, null));
				dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_COMPLETE, this));
//				dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_COMPLETE, this));
			}
		}

		private function SendProgress(PercentLoadedNum:Number, bLoaded:int=0, bTotal:int=0, e_target:Object=null):void
		{
			var PercentLoaded:int=Math.floor(PercentLoadedNum);

			var totlen:int=loadurl.length;
			TotalLoadeded=int(Math.round(n / totlen * 100) + Math.round(1 / totlen * PercentLoaded));

			var list:String=n + "/" + int(totlen - 1);

			//
			var n2:int=n + 1;
			if (n2 >= totlen)
			{
				n2=totlen;
			}

			var list2:String=n2 + "/" + totlen.toString();


			var arr:Array=[PercentLoaded, TotalLoadeded, list, names, bLoaded, bTotal, e_target, list2];
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_PROGRESS, arr));
		}

		/**
		 * fux
		 */
		private var second:Boolean=false;
		public static var second_complete:Boolean=false;
		/**
		 * andy game_index拆分后，先加载主界面，再加载剩余几个模块
		 */
		private var third:Boolean=false;
		public static var third_complete:Boolean=false;

		private var four:Boolean=false;

		private var info0_b:Boolean=false;

		public function loading_remain0():void
		{
			info0_b=true;
			loadurl=[];
			n=0;

			for (var i:int=0; i < info0.length; i++)
			{
				loadurl.push(info0[i]);
			}
//			loading(loadurl[0]);
			load(loadurl);
		}
		
		public function loading_selectRole():void
		{
			info0_b=true;
			loadurl=[];
			n=0;
			
			for (var i:int=0; i < info0.length; i++)
			{
				loadurl.push(info0[i]);
			}
//			loading(loadurl[1]);
			load(loadurl);
		}
		

		public function loading_remain1():void
		{
			if (!second)
			{
				second=true;
				loadurl=[];
				n=0;

				for (var i:int=0; i < info1.length; i++)
				{
					loadurl.push(info1[i]);
				}

				load(loadurl);
					//loading(loadurl[0]);
			}
		}

		public function loading_remain2():void
		{
			if (!third)
			{
				third=true;


				loadurl=[];
				n=0;

				var len:int=info2.length;

				for (var i:int=0; i < len; i++)
				{
					//loadurl.push(info2[i]);
					loadurl.push(info2.shift());
				}
				if (loadurl.length > 0)
				{
					loading(loadurl[0]);
				}
			}
		}

		public function loading_remain3():void
		{
			four=true;
		}

		public function sort(swfName2:String):Boolean
		{
			var sorted:Boolean=false;

			if ("" == swfName2 || null == swfName2)
			{
				return sorted;
			}

			//未加载的
			var startIndex:int=n + 1;

			var i:int;
			var len:int=this.loadurl.length;

			if (startIndex >= len)
			{
				return sorted;
			}

			for (i=startIndex; i < len; i++)
			{
				var sUrl:String=loadurl[i];
				var swfName:String=getFileName(sUrl);

				if (swfName == swfName2)
				{
					var sUrl2:String=loadurl[startIndex];
					loadurl[startIndex]=sUrl;
					loadurl[i]=sUrl2;
					sorted=true;
					break;
				}
			}

			return sorted;



		}

	}
}
