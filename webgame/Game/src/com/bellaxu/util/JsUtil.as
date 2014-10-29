package com.bellaxu.util
{
	import com.bellaxu.data.GameData;
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * js调用
	 * @author BellaXu
	 */
	public class JsUtil
	{
		private static var _gameConfig:Object;
		
		/**
		 * 获取配置
		 */
		public static function getGameConfig():Object
		{
			if(_gameConfig) return _gameConfig;
			return ExternalInterface.available ? ExternalInterface.call("getClientConfig") : null;
		}
		
		/**
		 * 添加收藏
		 */
		public static function addFavorite():void
		{
			if(ExternalInterface.available)
				ExternalInterface.call("bookmark");
		}
		
		/**
		 * 导航至url
		 */
		public static function navigateTo(url:String):void
		{
			navigateToURL(new URLRequest(url), "_blank");
		}
		
		/**
		 * 刷新页面
		 */
		public static function refresh():void
		{
			if(ExternalInterface.available)
				ExternalInterface.call("refreshpage");
		}
		
		/**
		 * 下载微端
		 */		
		public static function downloadWeiduan():void
		{
			navigateToURL(new URLRequest(GameData.url_weiduan), "_blank");
		}
		
		/**
		 * 保存游戏快捷方式到桌面 
		 */
		public static function saveHomePage():void
		{
			navigateToURL(new URLRequest(GameData.serverUrl + "/DownUrl.aspx"), "_blank");
		}
		
		/**
		 * 论坛
		 */
		public static function bbs():void
		{
			navigateToURL(new URLRequest(GameData.url_bbs), "_blank");
		}
		
		/**
		 * vip
		 */
		public static function vip():void
		{
			navigateToURL(new URLRequest(GameData.url_vip), "_blank");
		}
		
		/**
		 * 授权
		 */
		public static function authorized():void
		{
			navigateToURL(new URLRequest(GameData.url_authorized), "_blank");
		}
		
		/**
		 * 贵宾服务
		 */ 
		public static function VipService():void
		{
			navigateToURL(new URLRequest(GameData.url_VipService), "_blank");
		}
	}
}