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
	import netc.packets2.PacketWCGuildTreeInfo2;
	
	import engine.support.IPacket;
	
	public class PacketWCGuildTreeInfoProcess extends PacketBaseProcess
	{
		public function PacketWCGuildTreeInfoProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1			
			var p:PacketWCGuildTreeInfo2 = pack as PacketWCGuildTreeInfo2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//step 2		
			Data.bangPai.syncGuildTreeInfo(p);
			
			return p;
		}
		
		
	}
}