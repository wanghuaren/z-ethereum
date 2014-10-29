package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCActiveGuildItem2;

	public class PacketSCActiveGuildItemProcess extends PacketBaseProcess
	{
		public function PacketSCActiveGuildItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCActiveGuildItem2=pack as PacketSCActiveGuildItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}