package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetTenMinutesInfo2;

	public class PacketCSGetTenMinutesInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetTenMinutesInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetTenMinutesInfo2=pack as PacketCSGetTenMinutesInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}