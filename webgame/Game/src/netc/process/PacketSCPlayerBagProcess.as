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
	
	import netc.Data;
	import engine.net.process.PacketBaseProcess;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCPlayerBag2;
	
	public class PacketSCPlayerBagProcess extends PacketBaseProcess
	{
		public function PacketSCPlayerBagProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCPlayerBag2 = pack as PacketSCPlayerBag2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			/**2011-12-26 
			  背包，仓库，装备全部数据	
			  第一次进入游戏或背包版本不一致时调用
			*/
			Data.packZone.put(p.GetId(),p);
			Data.beiBao.reloadData();
			return p;
		}
	}
}