package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSMoveSpeedChange2;

	public class PacketCSMoveSpeedChangeProcess extends PacketBaseProcess
	{
		public function PacketCSMoveSpeedChangeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSMoveSpeedChange2=pack as PacketCSMoveSpeedChange2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}