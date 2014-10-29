package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCPayChangeExp22;

	public class PacketSCPayChangeExp2Process extends PacketBaseProcess
	{
		public function PacketSCPayChangeExp2Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCPayChangeExp22=pack as PacketSCPayChangeExp22;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}