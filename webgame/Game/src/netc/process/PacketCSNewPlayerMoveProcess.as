package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSNewPlayerMove2;

	public class PacketCSNewPlayerMoveProcess extends PacketBaseProcess
	{
		public function PacketCSNewPlayerMoveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSNewPlayerMove2=pack as PacketCSNewPlayerMove2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}