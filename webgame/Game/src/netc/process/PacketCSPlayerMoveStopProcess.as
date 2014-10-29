package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerMoveStop2;

	public class PacketCSPlayerMoveStopProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerMoveStopProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerMoveStop2=pack as PacketCSPlayerMoveStop2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}