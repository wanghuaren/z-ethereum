package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructCampPlayerRankInfo2;

	public class StructCampPlayerRankInfoProcess extends PacketBaseProcess
	{
		public function StructCampPlayerRankInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructCampPlayerRankInfo2=pack as StructCampPlayerRankInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}