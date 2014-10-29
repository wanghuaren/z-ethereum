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
	import netc.packets2.PacketSCArList2;
	import netc.packets2.StructActRecList2;
	
	import engine.support.IPacket;
	import nets.packets.PacketGCRoleLogin;
	
	
	public class PacketSCArListProcess extends PacketBaseProcess
	{
		public function PacketSCArListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			//step 1
			var p:PacketSCArList2 = pack as PacketSCArList2;
			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
//			if(p.sort == 2 ||
//				p.sort == 3 ||
//				p.sort == 4 ||
//				p.sort == 5 ||
//				p.sort == 6 ||
//				p.sort == 7)
//			{
//				ChengJiu2.arList[p.sort - 2]=new Vector.<StructActRecList2>().concat(p.arrItemactlist);
//		
//				if (p.ar_point > 0)
//				{
//					ChengJiu2.point=p.ar_point;				
//				}
//			}
			
			//
			Data.huoDong.syncByArList(p);
			
						
			return p;
		}
		
		
	}
}