/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import netc.MsgPrint;
	import engine.net.process.PacketBaseProcess;
	
	import engine.support.IPacket;
	import nets.packets.PacketCGRoleLogin;
	import nets.packets.PacketDCRoleList;
	import nets.packets.PacketGCRoleLogin;
	
	import netc.packets2.PacketSCDestroyItem2;
	
	public class PacketSCDestroyItemProcess extends PacketBaseProcess
	{
		public function PacketSCDestroyItemProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{			
			//step 1
			var p:PacketSCDestroyItem2 = pack as PacketSCDestroyItem2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
			//var list2:StructFriendList2 = new StructFriendList2();
			
			//var list:StructFriendList = p.friend_info;
			
			//
			//MsgPrint.packHelp.helpByReflect(
			
			
			
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}

