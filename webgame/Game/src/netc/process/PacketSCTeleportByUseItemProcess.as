package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTeleportByUseItem2;

	public class PacketSCTeleportByUseItemProcess extends PacketBaseProcess
	{
		public function PacketSCTeleportByUseItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTeleportByUseItem2=pack as PacketSCTeleportByUseItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}