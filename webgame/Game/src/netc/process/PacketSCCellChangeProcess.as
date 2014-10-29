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
	import netc.MsgPrint;
	import netc.dataset.BeiBaoSet;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCCellChange2;
	import netc.packets2.StructBagCell2;
	
	import engine.support.IPacket;
	import nets.packets.PacketCGRoleLogin;
	import nets.packets.PacketDCRoleList;
	import nets.packets.PacketGCRoleLogin;
	
	
	public class PacketSCCellChangeProcess extends PacketBaseProcess
	{
		public function PacketSCCellChangeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{			
			//step 1
			var p:PacketSCCellChange2 = pack as PacketSCCellChange2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			//2011-12-26
			//Data.beiBao.beiBaoDataChange(p.arrItemitem_list,p.version,p.newitem);
			Data.beiBao.queueBeiBaoDataChange(p.arrItemitem_list,p.version,p.newitem);
			

			return p;
		}
		
		
		
		
		
		
		
		
	}
}

