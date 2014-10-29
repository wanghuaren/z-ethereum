package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetCampActRankAward2;

	public class PacketCSGetCampActRankAwardProcess extends PacketBaseProcess
	{
		public function PacketCSGetCampActRankAwardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetCampActRankAward2=pack as PacketCSGetCampActRankAward2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}