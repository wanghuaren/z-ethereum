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
	import netc.dataset.BeatBackInfo;
	import engine.net.process.PacketBaseProcess;
	import netc.packets2.PacketSCBeatBackAdd2;
	
	import engine.support.IPacket;
	
	public class PacketSCBeatBackAddProcess extends PacketBaseProcess
	{
		public function PacketSCBeatBackAddProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			//step 1
			var p:PacketSCBeatBackAdd2 = pack as PacketSCBeatBackAdd2;			
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			//			
			Data.myKing.addFanJi(p.objid);
			
			
			return p;
		}
	}
}