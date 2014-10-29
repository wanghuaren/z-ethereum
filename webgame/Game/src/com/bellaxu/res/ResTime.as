package com.bellaxu.res
{
	import com.bellaxu.def.ResPathDef;
	import com.bellaxu.def.ResTimeDef;
	import com.bellaxu.util.JsUtil;
	import com.bellaxu.util.MathUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 * 资源版本日期
	 * @author BellaXu
	 */
	internal class ResTime
	{
		public static function getTime(url:String):String
		{
			if(url == ResPathDef.TIME_DAT)
			{
				var gameConfig:Object = JsUtil.getGameConfig();
				if(gameConfig)
					return gameConfig[ResTimeDef.TIME_DAT];
			}
			else
			{
				var pathDic:Dictionary = ResDat.getDatByPath(ResPathDef.TIME_DAT);
				if(pathDic && pathDic[url] != undefined)
					return pathDic[url];
			}
			//找不到版本，就返回随机版本
			var ran:int = MathUtil.getRandomInt(10000, 99999);
			return ran.toString();
		}
	}
}