package com.bellaxu.data
{
	import flash.utils.Dictionary;

	/**
	 * 配置数据基类
	 * @author BellaXu
	 */
	public class DataBase
	{
		protected var _dataDic:Dictionary;
		
		public function DataBase()
		{
			_dataDic = new Dictionary();
			init();
		}
		
		protected function init():void
		{
			
		}
		
		public function getData(key:String):*
		{
			return _dataDic[key];
		}
		
		public function setData(key:String, value:*):void
		{
			_dataDic[key] = value;
		}
	}
}