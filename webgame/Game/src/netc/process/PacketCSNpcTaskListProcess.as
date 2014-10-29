/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	
	import engine.support.IPacket;
	import nets.packets.PacketDCRoleList;
	import nets.packets.PacketGCRoleLogin;
	import nets.packets.PacketCSNpcTaskList;
	import netc.packets2.PacketCSNpcTaskList2;
	
	public class PacketCSNpcTaskListProcess extends PacketBaseProcess
	{
		public function PacketCSNpcTaskListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			
			//step 1
			var p:PacketCSNpcTaskList2 = pack as PacketCSNpcTaskList2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}