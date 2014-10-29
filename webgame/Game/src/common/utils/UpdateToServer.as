package common.utils
{
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.utils.Timer;

	import common.config.GameIni;
	import common.config.PubData;

	import common.utils.md5.MD5;

	/**
	 * 保存客户端自定义数据
	 * @author  WangHuaRen
	 * @version 2012-6-11-下午02:54:12
	 */
	public final class UpdateToServer
	{
		private static var _instance:UpdateToServer=null;
		private const code:String="D#FFDrf444dd__4sx";

		public static function get instance():UpdateToServer
		{
			if (_instance == null)
			{
				_instance=new UpdateToServer();
			}
			return _instance;
		}

		public function UpdateToServer()
		{
			urlRequest.url=GameIni.wangzhi == "" ? "http://x1.677.com/api/clientlog.aspx" : GameIni.wangzhi;
			lock=true;
//			timer.addEventListener(TimerEvent.TIMER, timerHandler);
//			timer.start();
		}
		private var netVar:URLVariables=new URLVariables();
		private var urlRequest:URLRequest=new URLRequest();
		private var p2:String;
		private var lock:Boolean;
		private var timer:Timer=new Timer(10000, 1);
		//private var test:Boolean=false;

		private function timerHandler(e:TimerEvent):void
		{
			if (PubData.accountID == 0)
			{
				lock=false;
				p2=MD5.hash(PubData.accountID + code);
//				send("超过10秒登录未反应,当前状态:" + PubData.LoginRecordStatus);
				lock=true;
			}
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
		}

		/**
		 * 向服务端保存数据
		 * @param value 要存入的数据
		 * @param act   del表示把本账号数据清除
		 * */
//		public function send(value:String, sort:int=0, para:String=null, act:String=null):void
		public function send():void
		{
			if (PubData.accountID != 0 && lock)
			{
				p2=MD5.hash(PubData.accountID + code);
				lock=false;
			}
			if (!lock)
			{
				netVar=new URLVariables();
//				netVar.decode("p2=" + p2 + "&p1=" + PubData.accountID + "&p3=" + value + "&act=" + act + "&sort=" + sort + "&para=" + para);
				urlRequest.data=netVar;
				sendToURL(urlRequest);
			}
		}
	}
}
