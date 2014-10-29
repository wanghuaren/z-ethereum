package netc
{
	import engine.event.DispatchEvent;

	import flash.utils.Dictionary;

	import engine.support.IProcess;

	import engine.support.IPacket;

	public class DataKeyProcess
	{
		private static var _processMap:Dictionary=new Dictionary();

		public static function RegisterPacketType(pId:int, p:IProcess):void
		{
			_processMap[pId]=p;
		}

		/**
		 * 组合数据给上层界面逻辑
		 *
		 * 如遇报错，_processMap[pId]返回为空
		 * 在ProcessRegister类中注册相应处理函数
		 */
		//public static function process(pack:IPacket):Array
		public static function process(pack:IPacket):IPacket
		{
			var pId:int=pack.GetId();

			if (null == _processMap[pId] || undefined == _processMap[pId])
			{
				//TODO 发布的时候一些打印需要去除
				MsgPrint.printTrace("未在ProcessRegister类中注册相应处理函数,packId:" + pId.toString(), MsgPrintType.SOCKET_DATA_PROCESS);

				//直接略过process处理的返回
				return pack;
			}

			return (_processMap[pId] as IProcess).process(pack);
		}
	}
}
