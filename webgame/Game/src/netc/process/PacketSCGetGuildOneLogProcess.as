package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildOneLog2;

	public class PacketSCGetGuildOneLogProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildOneLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildOneLog2=pack as PacketSCGetGuildOneLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}