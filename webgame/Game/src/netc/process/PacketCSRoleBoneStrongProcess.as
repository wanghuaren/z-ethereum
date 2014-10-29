package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSRoleBoneStrong2;

	public class PacketCSRoleBoneStrongProcess extends PacketBaseProcess
	{
		public function PacketCSRoleBoneStrongProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSRoleBoneStrong2=pack as PacketCSRoleBoneStrong2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}