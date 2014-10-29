package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetTameDragonRank2;

	public class PacketCSGetTameDragonRankProcess extends PacketBaseProcess
	{
		public function PacketCSGetTameDragonRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetTameDragonRank2=pack as PacketCSGetTameDragonRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}