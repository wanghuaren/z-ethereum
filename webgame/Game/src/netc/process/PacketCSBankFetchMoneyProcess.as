package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSBankFetchMoney2;

	public class PacketCSBankFetchMoneyProcess extends PacketBaseProcess
	{
		public function PacketCSBankFetchMoneyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSBankFetchMoney2=pack as PacketCSBankFetchMoney2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}