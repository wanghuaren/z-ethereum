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
	import netc.packets2.PacketSCMove2;
	
	import engine.support.IPacket;
	
	public class PacketSCMoveProcess extends PacketBaseProcess
	{
		public function PacketSCMoveProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			
			//step 1
			var p:PacketSCMove2 = pack as PacketSCMove2;			
			
			if(null == p)
			{ 
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}    
						
			//空闲清零
			if(null != Data.myKing.king)
			{
				if(p.aid == Data.myKing.king.objid)
				{
					Data.idleTime.syncByClearIdleXiuLian();
					Data.idleTime.syncByClearIdleNewGuest();
				}
			}
			
			return p;
		}
		
		
	}
}