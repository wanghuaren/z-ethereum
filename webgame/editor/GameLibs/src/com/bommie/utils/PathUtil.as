package com.bommie.utils
{
	

	/**
	 * 路径常量
	 * @author Bommie
	 */
	public class PathUtil 
	{
		/**
		 * 取相对路径
		 */
        public static function getTrimPath(url:String) : String
        {
            var str:String = url;
			//项目转换修改
//			var i1:int = str.indexOf(GameData.GAMESERVERS);
//			if(i1 > -1)
//			{
//				str = str.replace(GameData.GAMESERVERS, "");
//			}
			var i2:int = str.indexOf("?");
			if(i2 > -1)
				str = str.substring(0, i2);
            return str;
        }
		
		/**
		 * 获取全路径
		 */
		public static function getFullPath(url:String) : String
		{
			//项目转换修改
//			return url == ResPathDef.GAME_MAIN_TEST ? url : GameData.GAMESERVERS + url;
//			return url == ResPathDef.GAME_MAIN_TEST||url.indexOf("http")==0 ? url : GameIni._http0 + url;
			return url;
		}
		
		/**
		 * 解析文件名
		 */
		public static function getFileName(url:String):String
		{
			var i1:int = url.lastIndexOf("/");
			if(i1==-1){
				i1=url.lastIndexOf("\\");
			}
			var i2:int = url.lastIndexOf(".");
			i1 = i1 > -1 ? i1 + 1 : 0;
			i2 = i2 > -1 ? i2 : url.length;
			return url.substring(i1, i2);
		}
	}
}