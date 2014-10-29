package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCampRank2;

	public class StructCampRankProcess extends PacketBaseProcess
	{
		public function StructCampRankProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCampRank2=pack as StructCampRank2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}