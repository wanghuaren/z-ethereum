package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildAutoAccess2;

	public class PacketCSGuildAutoAccessProcess extends PacketBaseProcess
	{
		public function PacketCSGuildAutoAccessProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildAutoAccess2=pack as PacketCSGuildAutoAccess2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}