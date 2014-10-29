/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import engine.support.IPacket;
	import nets.packets.PacketGCServerList;
	import nets.packets.PacketDCRoleHeadList;
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCFight2;
	
	import scene.king.IGameKing;
	
	public class PacketSCFightProcess extends PacketBaseProcess
	{
		public function PacketSCFightProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCFight2 = pack as PacketSCFight2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
						
			//lock release
			var srcKingA:IGameKing=Data.myKing.king;
			
			if (null != srcKingA)
			{
				srcKingA.fightInfo.CSFightLock=false;
				
							}
			
			//step 2		
			//DataCenter.packZone.put(p.GetId(),p);
			
			return p;
		}
	}
}