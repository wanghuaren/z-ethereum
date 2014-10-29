package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetNationalDayState2;

	public class PacketCSGetNationalDayStateProcess extends PacketBaseProcess
	{
		public function PacketCSGetNationalDayStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetNationalDayState2=pack as PacketCSGetNationalDayState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}