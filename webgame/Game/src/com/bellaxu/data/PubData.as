package com.bellaxu.data
{
	import com.bellaxu.debug.Debug;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSClientDataSet;
	
	/**
	 * 需要和服务器交互的数据
	 * @author BellaXu
	 */
	public class PubData
	{
		private static var dataSet:PacketCSClientDataSet = new PacketCSClientDataSet();
		
		public static function response(index:int,value:int):void
		{
			dataSet.data['para' + index] = value;
		}
		
		public static function save(index:int, value:int):void
		{
			if(index < 1 || index > 4)
			{
				Debug.error("index range must 1 - 4");
				return;
			}
			if(-1 == value)
			{
				Debug.error("value range must 1 - FFFF");
				return;
			}
			dataSet.data['para' + index] = value;
			upToServer();
		}
		
		public static function upToServer():void
		{
			DataKey.instance.send(dataSet);
		}
	}
}