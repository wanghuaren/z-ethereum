package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetTenMinutesInfo2;

	public class PacketSCGetTenMinutesInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetTenMinutesInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetTenMinutesInfo2=pack as PacketSCGetTenMinutesInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}