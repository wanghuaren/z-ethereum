/**
 * 该类名为Process，即处理类
 * 该类不可以有变量，函数为处理数据，加工，存储等并返回结果
 * 可保存数据至DataCenter中
 * 
 */ 
package netc.process
{
	import flash.utils.getQualifiedClassName;
	
	import engine.net.process.PacketBaseProcess;
	
	import engine.support.IPacket;
	import netc.packets2.PacketSCSayMap2;
	
	public class PacketSCSayMapProcess extends PacketBaseProcess
	{
		public function PacketSCSayMapProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCSayMap2 = pack as PacketSCSayMap2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			p.content_primitve = p.content;
			
			return p;
		}
	}
}