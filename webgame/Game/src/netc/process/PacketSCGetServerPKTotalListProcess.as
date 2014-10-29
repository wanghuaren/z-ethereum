package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetServerPKTotalList2;

	public class PacketSCGetServerPKTotalListProcess extends PacketBaseProcess
	{
		public function PacketSCGetServerPKTotalListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetServerPKTotalList2=pack as PacketSCGetServerPKTotalList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}