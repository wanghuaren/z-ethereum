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
	import netc.dataset.MoTianSet;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCFightValue2;
	
	import engine.support.IPacket;
	import nets.packets.PacketDCRoleHeadList;
	import nets.packets.PacketGCServerList;
	
	public class PacketSCFightValueProcess extends PacketBaseProcess
	{
		public function PacketSCFightValueProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCFightValue2 = pack as PacketSCFightValue2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			var value:PacketSCFightValue2 = pack as PacketSCFightValue2;
			var zl:int = value.player+value.pet+value.playerequipbase+value.playerequipstrong
				+value.playerequipapp+value.petequipbase+value.petequipstrong+value.petequipapp+value.playerstart
				+value.petstart+value.playerpill+value.petpill+value.playerhourse+value.playerbone;
			
			Data.myKing.setZhanLi = zl;
			
			return p;
		}
	}
}