package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCGetSHJoinList2;
	
	public class PacketSCGetSHJoinListProcess extends PacketBaseProcess
	{
		public function PacketSCGetSHJoinListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSHJoinList2=pack as PacketSCGetSHJoinList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}