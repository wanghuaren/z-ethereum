/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import common.config.PubData;
	
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketDCRoleList2;
	
	import engine.support.IPacket;
	import nets.packets.PacketDCRoleList;
	import nets.packets.PacketGCRoleLogin;
	
	public class PacketDCRoleListProcess extends PacketBaseProcess
	{
		public function PacketDCRoleListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			
			//step 1
			var p:PacketDCRoleList2 = pack as PacketDCRoleList2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//sync
			if(p.arrItemroleList.length > 0)
			{
				//PubData.data = p.arrItemroleList[0].data;
				PubData.para1 = p.arrItemroleList[0].data.para1;
				PubData.para2 = p.arrItemroleList[0].data.para2;
				PubData.para3 = p.arrItemroleList[0].data.para3;
				PubData.para4 = p.arrItemroleList[0].data.para4;
			}
			
			return p;
		}
		
		
		
		
		
		
		
		
		
		
	}
}