package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTaskAwardFresh2;

	public class PacketCSTaskAwardFreshProcess extends PacketBaseProcess
	{
		public function PacketCSTaskAwardFreshProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTaskAwardFresh2=pack as PacketCSTaskAwardFresh2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}