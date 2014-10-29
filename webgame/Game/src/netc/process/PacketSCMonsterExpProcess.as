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
	import netc.packets2.PacketSCMonsterExp2;
	
	import engine.support.IPacket;
	
	public class PacketSCMonsterExpProcess extends PacketBaseProcess
	{
		public function PacketSCMonsterExpProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketSCMonsterExp2 = pack as PacketSCMonsterExp2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			if(p.objid == Data.myKing.objid)
			{
				Data.myKing.syncByMonsterExp(p);
			}else
			{
				Data.monsterExp.syncByExpAdd(p);
			}			
			
			return p;
		}
		
		
		
		
		
		
		
		
	}
}