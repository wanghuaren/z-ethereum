/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCFriendDel2;
	
	import engine.support.IPacket;
	
	public class PacketWCFriendDelProcess extends PacketBaseProcess
	{
		public function PacketWCFriendDelProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketWCFriendDel2 = pack as PacketWCFriendDel2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2
			Data.haoYou.delHaoYou(p);
			return p;
		}
	}
}