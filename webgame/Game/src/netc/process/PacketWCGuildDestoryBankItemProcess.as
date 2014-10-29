package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCGuildDestoryBankItem2;

	public class PacketWCGuildDestoryBankItemProcess extends PacketBaseProcess
	{
		public function PacketWCGuildDestoryBankItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCGuildDestoryBankItem2=pack as PacketWCGuildDestoryBankItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}