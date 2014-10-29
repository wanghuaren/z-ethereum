package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTaskAwardTimeBuy2;

	public class PacketCSTaskAwardTimeBuyProcess extends PacketBaseProcess
	{
		public function PacketCSTaskAwardTimeBuyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTaskAwardTimeBuy2=pack as PacketCSTaskAwardTimeBuy2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}