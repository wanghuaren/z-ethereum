package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSRoleLoaded2;

	public class PacketCSRoleLoadedProcess extends PacketBaseProcess
	{
		public function PacketCSRoleLoadedProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSRoleLoaded2=pack as PacketCSRoleLoaded2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}