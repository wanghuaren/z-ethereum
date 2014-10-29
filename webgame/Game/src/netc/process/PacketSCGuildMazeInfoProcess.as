package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGuildMazeInfo2;

	public class PacketSCGuildMazeInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGuildMazeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGuildMazeInfo2=pack as PacketSCGuildMazeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}