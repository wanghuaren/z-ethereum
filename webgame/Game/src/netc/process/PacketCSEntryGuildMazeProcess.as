package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEntryGuildMaze2;

	public class PacketCSEntryGuildMazeProcess extends PacketBaseProcess
	{
		public function PacketCSEntryGuildMazeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEntryGuildMaze2=pack as PacketCSEntryGuildMaze2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}