package common.config
{
	
	/**
	 * @author WangHuaRen
	 * @version 2011-4-14
	 **/
	public final class SelfConf
	{
		public static var uname:String="war002";

		//	七战 测试服
//		public static var p_id:String="10004";
//		public static var server:String="1";
		//	七战 开发服
		public static var p_id:String="10004";
		public static var server:String="4";
		//	七战 策划服
//		public static var p_id:String="10004";
//		public static var server:String="2";
		// 七战 测试服 IP
//		public static var serverIP:String="192.168.0.2:26099";
		// 七战 策划服 IP
//		public static var serverIP:String="192.168.0.2:25099";
		// 七战 开发服 IP
		public static var serverIP:String="192.168.0.2:24099";
		// 七战 叶俊 IP
//		public static var serverIP:String="192.168.0.164:8099";
		// 七战 李恪荣 IP
//		public static var serverIP:String="192.168.0.199:8099";
//		public static var serverIP:String="192.168.0.162:8099";

		
		/**
		 * 七战资源地址IP
		 * */
		public static var httpIP:String="http://192.168.0.172:8085/GameRes/";
//		public static var httpIP:String="http://192.168.0.2:8031/GameRes/";

		/**
		 * 需要记录保存至数据库中的客户端日志IP
		 **/
		public static var wangzhi:String="http://x1.677.com/api/clientlog.aspx";
	}
}