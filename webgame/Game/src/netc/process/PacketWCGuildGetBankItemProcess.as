package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCGuildGetBankItem2;

	public class PacketWCGuildGetBankItemProcess extends PacketBaseProcess
	{
		public function PacketWCGuildGetBankItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCGuildGetBankItem2=pack as PacketWCGuildGetBankItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}