package common.config.xmlres
{
	import engine.event.DispatchEvent;

	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	import war.EncryptTXML;

	public class Loadxml extends EventDispatcher
	{
		public static const _XOR:uint=124;
		private var loadurl:String;
		private var xmlLoader:URLLoader;
		public static var path:String="";
		public static var localres_complete:Boolean=false;

		public function Loadxml():void
		{
		}

		public function loadfile(url:String):void
		{
			loadurl=url;
			xmlLoader=new URLLoader();
			xmlLoader.dataFormat=URLLoaderDataFormat.BINARY;
			xmlLoader.addEventListener(Event.COMPLETE, loadEnd);
			xmlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadErr);
			xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			xmlLoader.load(new URLRequest(Loadxml.path + url));
		}

		private function progressHandler(e:ProgressEvent):void
		{
			if (isNaN(xmlLoader.bytesLoaded) || isNaN(xmlLoader.bytesTotal))
			{
				return;
			}
			if (!isFinite(xmlLoader.bytesLoaded) || !isFinite(xmlLoader.bytesTotal))
			{
				return;
			}
			var per:int=xmlLoader.bytesLoaded / xmlLoader.bytesTotal;
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_XML_LOAD_PER, per));
		}

		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			removeEvent();
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_XML_SECURITY_ERROR, ""));
		}

		private function loadErr(evt:IOErrorEvent=null):void
		{
			removeEvent();
			var msg:String="读入地址失败：" + loadurl;
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_IO_ERROR, msg));
		}

		private function httpStatus(evt:HTTPStatusEvent):void
		{
			if (evt.status == 404 || evt.status == 0)
			{
				loadErr();
			}
		}

		private function loadEnd(event:Event):void
		{
			if (xmlLoader.bytesLoaded < xmlLoader.bytesTotal)
			{
				loadErr();
				return;
			}
			var loaddata:String=null;
			if (loadurl.indexOf(".amd") > 0 || loadurl.indexOf(".AMD") > 0)
			{
				loaddata=EncryptTXML.instance.DeCode(xmlLoader.data, _XOR);
			}
			else
			{
				loaddata=EncryptTXML.instance.DeCode(xmlLoader.data);
			}
			removeEvent();
			dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_COMPLETE, loaddata));
		}

		private function removeEvent():void
		{
			//监听不能去掉,事件执行顺序不确定,删除后 ,后边事件会捕捉不到
			return;
			xmlLoader.removeEventListener(Event.COMPLETE, loadEnd);
			xmlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loadErr);
			xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
	}
}
