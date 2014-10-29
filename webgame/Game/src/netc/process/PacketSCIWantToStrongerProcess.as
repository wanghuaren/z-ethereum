package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCIWantToStronger2;

	public class PacketSCIWantToStrongerProcess extends PacketBaseProcess
	{
		public function PacketSCIWantToStrongerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCIWantToStronger2=pack as PacketSCIWantToStronger2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}