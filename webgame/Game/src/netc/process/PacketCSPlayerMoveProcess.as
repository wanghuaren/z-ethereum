package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerMove2;

	public class PacketCSPlayerMoveProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerMoveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerMove2=pack as PacketCSPlayerMove2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}