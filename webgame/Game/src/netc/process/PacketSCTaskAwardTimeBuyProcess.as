package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTaskAwardTimeBuy2;

	public class PacketSCTaskAwardTimeBuyProcess extends PacketBaseProcess
	{
		public function PacketSCTaskAwardTimeBuyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTaskAwardTimeBuy2=pack as PacketSCTaskAwardTimeBuy2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}