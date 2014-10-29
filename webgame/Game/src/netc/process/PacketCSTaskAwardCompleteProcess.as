package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTaskAwardComplete2;

	public class PacketCSTaskAwardCompleteProcess extends PacketBaseProcess
	{
		public function PacketCSTaskAwardCompleteProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTaskAwardComplete2=pack as PacketCSTaskAwardComplete2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}