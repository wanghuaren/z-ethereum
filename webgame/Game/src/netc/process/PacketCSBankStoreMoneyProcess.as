package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSBankStoreMoney2;

	public class PacketCSBankStoreMoneyProcess extends PacketBaseProcess
	{
		public function PacketCSBankStoreMoneyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSBankStoreMoney2=pack as PacketCSBankStoreMoney2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}