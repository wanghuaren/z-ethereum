package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructActCharRank2;

	public class StructActCharRankProcess extends PacketBaseProcess
	{
		public function StructActCharRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructActCharRank2=pack as StructActCharRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}