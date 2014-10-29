package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildTreeDrop2;

	public class PacketCSGuildTreeDropProcess extends PacketBaseProcess
	{
		public function PacketCSGuildTreeDropProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildTreeDrop2=pack as PacketCSGuildTreeDrop2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}