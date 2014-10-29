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
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCGetGuildBossTime2;
	
	import engine.support.IPacket;
	import nets.packets.PacketCGRoleLogin;
	import nets.packets.PacketDCRoleList;
	import nets.packets.PacketGCRoleLogin;
	
	public class PacketSCGetGuildBossTimeProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildBossTimeProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{			
			//step 1
			var p:PacketSCGetGuildBossTime2 = pack as PacketSCGetGuildBossTime2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//
			Data.jiaZu.syncByGuildMoreInfoByBossTime(p);
			
			Data.bangPai.syncGetGuildBossTime(p);
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}

