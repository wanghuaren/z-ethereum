package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCContinueLoginDays2;

	public class PacketSCContinueLoginDaysProcess extends PacketBaseProcess
	{
		public function PacketSCContinueLoginDaysProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCContinueLoginDays2=pack as PacketSCContinueLoginDays2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}