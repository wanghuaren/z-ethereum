package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructServerRank2;

	public class StructServerRankProcess extends PacketBaseProcess
	{
		public function StructServerRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructServerRank2=pack as StructServerRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}