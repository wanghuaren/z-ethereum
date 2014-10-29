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
	import netc.packets2.PacketSCHidePlayer2;
	
	public class PacketSCHidePlayerProcess extends PacketBaseProcess
	{
		public function PacketSCHidePlayerProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCHidePlayer2 = pack as PacketSCHidePlayer2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
		
		
		
	}
}