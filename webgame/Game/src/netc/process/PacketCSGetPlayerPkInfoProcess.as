package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetPlayerPkInfo2;

	public class PacketCSGetPlayerPkInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetPlayerPkInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetPlayerPkInfo2=pack as PacketCSGetPlayerPkInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}