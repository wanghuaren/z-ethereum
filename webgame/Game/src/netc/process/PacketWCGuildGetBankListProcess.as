package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketWCGuildGetBankList2;

	public class PacketWCGuildGetBankListProcess extends PacketBaseProcess
	{
		public function PacketWCGuildGetBankListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCGuildGetBankList2=pack as PacketWCGuildGetBankList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			Data.bangPai.syncGuildGetBankList(p);
			
			return p;
		}
	}
}