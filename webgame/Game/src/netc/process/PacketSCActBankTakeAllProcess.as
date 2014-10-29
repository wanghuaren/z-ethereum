package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCActBankTakeAll2;

	public class PacketSCActBankTakeAllProcess extends PacketBaseProcess
	{
		public function PacketSCActBankTakeAllProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCActBankTakeAll2=pack as PacketSCActBankTakeAll2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}