package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetTameDragonRank2;

	public class PacketSCGetTameDragonRankProcess extends PacketBaseProcess
	{
		public function PacketSCGetTameDragonRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetTameDragonRank2=pack as PacketSCGetTameDragonRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}