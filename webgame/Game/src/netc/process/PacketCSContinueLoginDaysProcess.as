package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSContinueLoginDays2;

	public class PacketCSContinueLoginDaysProcess extends PacketBaseProcess
	{
		public function PacketCSContinueLoginDaysProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSContinueLoginDays2=pack as PacketCSContinueLoginDays2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}