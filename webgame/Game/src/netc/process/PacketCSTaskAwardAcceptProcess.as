package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTaskAwardAccept2;

	public class PacketCSTaskAwardAcceptProcess extends PacketBaseProcess
	{
		public function PacketCSTaskAwardAcceptProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTaskAwardAccept2=pack as PacketCSTaskAwardAccept2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}