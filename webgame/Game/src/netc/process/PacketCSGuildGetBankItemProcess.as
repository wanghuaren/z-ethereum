package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildGetBankItem2;

	public class PacketCSGuildGetBankItemProcess extends PacketBaseProcess
	{
		public function PacketCSGuildGetBankItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildGetBankItem2=pack as PacketCSGuildGetBankItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}