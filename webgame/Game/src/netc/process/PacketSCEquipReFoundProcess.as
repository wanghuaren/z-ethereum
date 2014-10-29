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
	import netc.packets2.PacketSCEquipReFound2;
	
	import engine.support.IPacket;
	
	public class PacketSCEquipReFoundProcess extends PacketBaseProcess
	{
		public function PacketSCEquipReFoundProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCEquipReFound2 = pack as PacketSCEquipReFound2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
		
			//step 2		
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}