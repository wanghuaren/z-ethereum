package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSRankTopAward2;

	public class PacketCSRankTopAwardProcess extends PacketBaseProcess
	{
		public function PacketCSRankTopAwardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSRankTopAward2=pack as PacketCSRankTopAward2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}