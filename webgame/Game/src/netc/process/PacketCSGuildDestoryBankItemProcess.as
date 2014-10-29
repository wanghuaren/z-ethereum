package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildDestoryBankItem2;

	public class PacketCSGuildDestoryBankItemProcess extends PacketBaseProcess
	{
		public function PacketCSGuildDestoryBankItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildDestoryBankItem2=pack as PacketCSGuildDestoryBankItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}