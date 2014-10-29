package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWDSayRoleInfo2;

	public class PacketWDSayRoleInfoProcess extends PacketBaseProcess
	{
		public function PacketWDSayRoleInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWDSayRoleInfo2=pack as PacketWDSayRoleInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}