package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSRoleChangeMap2;

	public class PacketCSRoleChangeMapProcess extends PacketBaseProcess
	{
		public function PacketCSRoleChangeMapProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSRoleChangeMap2=pack as PacketCSRoleChangeMap2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}