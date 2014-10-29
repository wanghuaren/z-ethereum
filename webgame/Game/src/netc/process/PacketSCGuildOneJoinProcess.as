package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGuildOneJoin2;

	public class PacketSCGuildOneJoinProcess extends PacketBaseProcess
	{
		public function PacketSCGuildOneJoinProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGuildOneJoin2=pack as PacketSCGuildOneJoin2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}