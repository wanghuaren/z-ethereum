package netc
{
	public class MsgPrintType
	{
		/**
		 * 网络连接
		 */ 
		public static const SOCKET_CONNECT:String = "socketConnect";
		
		/**
		 * 网络数据发送
		 */ 		
		public static const SOCKET_SEND:String = "socketSend";
		
		/**
		 * 网络数据接收
		 */ 		
		public static const SOCKET_RECV:String = "socketRecv";
		
		/**
		 * try-catch中的异常
		 */ 		
		public static const  WINDOW_ERROR:String = "windowError";
		
		/**
		 * 网络数据Process处理
		 */ 		
		public static const SOCKET_DATA_PROCESS:String = "socketDataProcess";
		
		/**
		 * 本地面板刷新
		 */
		public static const WINDOW_REFRESH:String = "windowRefresh"; 
		
		/**
		 * 定时器事件
		 */ 
		public static const TIMER_TICK:String = "timerTick"; 
		
		
		public function MsgPrintType()
		{
		}
	}
}