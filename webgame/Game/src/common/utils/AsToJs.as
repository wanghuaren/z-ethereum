package common.utils
{
	import engine.utils.Debug;
	import flash.external.ExternalInterface;
	import ui.view.zhenbaoge.ZhenBaoGeWin;

	// suhang js和as交互 曾经导致game_loading不能编译
	public class AsToJs
	{
		// 浏览器种类  IE 1     火狐 2
		private static var _browser:int=0;
		private static var _instance:AsToJs;

		public static function get instance():AsToJs
		{
			if (_instance == null)
			{
				_instance=new AsToJs();
			}
			return _instance;
		}

		public static function get browser():int
		{
			if (_browser == 0)
			{
				_browser=int(callJS("getBrowser"));
			}
			return _browser;
		}

		public static function set browser(value:int):void
		{
			_browser=value;
		}

		// name:js的方法名   para：参数
		public static function callJS(name:String, ... parameters):Object
		{
			try
			{
				return ExternalInterface.call(name, parameters);
			}
			catch (e:Error)
			{
				trace(e.message)
			}
			return null;
		}

		/**
		 * openobj:0自己，1他人
		 * */
		public static function callJS_centerPay(name:String, day:int, isSelf:int):Object
		{
			try
			{
				return ExternalInterface.call(name, day, isSelf);
			}
			catch (e:Error)
			{
				trace(e.message)
			}
			return null;
		}

		//title, summary, msg, img
		public function callJS_tweet(value:String, title:String, summary:String, msg:String, img:String, button:String, source:String, context:String):Object
		{
			try
			{
				return ExternalInterface.call(value, title, summary, msg, img, button, source, context);
			}
			catch (e:Error)
			{
			}
			return null;
		}

		public function callJS_invite(value:String):Object
		{
			return callJS(value);
		}

		// name:js的方法名   fun：回调函数
		public static function callJSBack(name:String, fun:Function):void
		{
			try
			{
				ExternalInterface.addCallback(name, fun);
			}
			catch (e:Error)
			{
				trace("ExternalInterface.addCallback 错误:" + e.message);
			}
		}

		// 设置浏览器大小   return： 宽和高  逗号隔开
		public static function setBrowser(width:int=0, heigth:int=0):Object
		{
			return callJS("setBrowser", width, heigth);
		}

		/**
		 * 点击任务集市图标调用的JS
		 * */
		public static function showTask():Object
		{
			return callJS("ShowTask");
		}

		/**
		 * 注册任务集市给JS调用
		 * */
		public static function regShowTask():void
		{
			var methodName:String="showTask";
			callJSBack(methodName, showTask);
		}

		/**
		 * 注册珍宝阁给JS调用
		 * */
		public static function regShowShop(method:Function):void
		{
			var methodName:String="showShop";
			callJSBack(methodName, method);
		}

		/**
		 * 点击调用添加QQ面板的JS
		 * */
		public static function addQQPanel():Object
		{
			return callJS("addQQPanel");
		}

		/**
		 * 注册添加QQ面板调用的返回
		 * */
		public static function regAddQQPanel(method:Function):void
		{
			var methodName:String="addQQPanelOK";
			callJSBack(methodName, method);
		}

		public static function RightClick(method:Function):void
		{
			var methodName:String="rightClickDown";
			callJSBack(methodName, method);
		}
	}
}
