package engine.net
{
	import engine.utils.Debug;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	/**
	 * @author andy
	 * @date   2011-03-05
	 * http通讯
	 */
	public class SendPackage
	{
		private var url:String;
		private var callFunction:Function;
		private var returnParam:*;		
		private var md5:Boolean=false;
		private var arr_item:Array = new Array();
		private var loader:URLLoader=null;
		
		private static var instance:SendPackage =null;
		public static function getInstance():SendPackage {
			if(instance ==null)
				instance=new SendPackage();
			return instance;
		}
		
		public function SendPackage() {}
		
		
		/**
		 * @param u  http路径
		 * @param f  回调函数
		 * @param ob 传入参数返回
		 * @param m  是否加密
		 * @param r  http请求方式，默认post
		 */		
		public function sendData(u:String, f:Function = null,rp:*=null,m:Boolean = false,r:String="POST"):void {
			this.url = u + "?v="+new Date().getTime();
			this.callFunction = f;
			this.returnParam = rp;
			this.md5=m;
			
			var param:String=getParam();
			var variables:URLVariables = new URLVariables(param);
			var request:URLRequest = new URLRequest(url);
			request.method = r;
			request.data = variables;
			//Debug.instance.traceMsg("url",url,"param",param);
			loader = new URLLoader();
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,secErr);
		}
		private function loadErrorHandler(event:IOErrorEvent):void {
			Debug.instance.traceMsg("http请求失败io:url="+this.url);
			if (this.callFunction != null) callFunction(null,returnParam);
		}
		private function secErr(event:IOErrorEvent):void {
			Debug.instance.traceMsg("http请求失败sec:url="+this.url);
			if (this.callFunction != null) callFunction(null,returnParam);
		}
		
		
		private function completeHandler(event:Event):void {;
			var xml:XML = new XML(loader.data);
			//Debug.instance.traceMsg(xml);	
			if (this.callFunction != null) callFunction(xml,returnParam);
		}
		//发送参数设置
		public function pushParam(key:String,value:String):void{
			arr_item.push({key:key,value:value});
		}
		
		public function getParam():String{
			var param:String="";
			for each(var item:Object in arr_item){
				param+=item.key+"="+item.value+"&";
			}
			if(param.length>0){
				param=param.substring(0,param.length-1);
			}
			//md5加密
			if(this.md5 == true){
				param = "param="+encrypt(param);
				var myPattern:RegExp = /\+/g;  
				param = param.replace(myPattern,"%2B");
			}
			return param;
		}
		//md5加密
		public  function encrypt(txt:String = ""):String {
			var ret:String = null;
			/*  try{
			var keyString:String = User.getInstance().getSec();
			var key:ByteArray = Hex.toArray(Hex.fromString(keyString));
			var src:String = Base64.encode(txt);
			var data:ByteArray = Hex.toArray(Hex.fromString(src));
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(type, key, pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.encrypt(data);
			ret = Base64.encodeByteArray(data);
			} catch (e:Error) {
			throw new Error("object format error");
			ret = null;
			}*/
			return ret;
		}

		
	}
	
}