package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructGuildMazePlayerInfo2;

	public class StructGuildMazePlayerInfoProcess extends PacketBaseProcess
	{
		public function StructGuildMazePlayerInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructGuildMazePlayerInfo2=pack as StructGuildMazePlayerInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}