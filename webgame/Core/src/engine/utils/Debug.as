package engine.utils
{

	/**
	 * @author  WangHuaRen
	 * @version 2012-1-11-上午09:49:17
	 */
	public final class Debug
	{
		private static var _instance:Debug=null;

		public static function get instance():Debug
		{
			if (_instance == null)
			{
				_instance=new Debug();
			}
			return _instance;
		}

		public function Debug()
		{
		}

		public function traceError(error:String, tag:*=null):void
		{
			//			throw new Error(error);
			var str:String=tag == null ? "打印错误信息:" + error : "打印错误信息:" + error + ".[" + tag + "]";
			//trace(str);
		}

		public function traceMsg(msg:*, tag:*=null):void
		{
//			var str:String=tag == null ? "打印调试信息:" + msg : "打印调试信息:" + msg + ".[" + tag + "]";
			trace(msg);
		}
	}
}