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
	import netc.dataset.HaoYouSet;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketWCFriendList2;
	
	import engine.support.IPacket;
	
	public class PacketWCFriendListProcess extends PacketBaseProcess
	{
		public function PacketWCFriendListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketWCFriendList2 = pack as PacketWCFriendList2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			Data.haoYou.setHaoYouList(p);
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}