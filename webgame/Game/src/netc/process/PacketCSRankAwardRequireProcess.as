package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSRankAwardRequire2;

	public class PacketCSRankAwardRequireProcess extends PacketBaseProcess
	{
		public function PacketCSRankAwardRequireProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSRankAwardRequire2=pack as PacketCSRankAwardRequire2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}