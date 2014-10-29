package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCAddSHJoinList2;
	
	public class PacketSCAddSHJoinListProcess extends PacketBaseProcess
	{
		public function PacketSCAddSHJoinListProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCAddSHJoinList2=pack as PacketSCAddSHJoinList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}