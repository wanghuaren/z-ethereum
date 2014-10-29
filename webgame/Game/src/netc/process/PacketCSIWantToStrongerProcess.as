package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSIWantToStronger2;

	public class PacketCSIWantToStrongerProcess extends PacketBaseProcess
	{
		public function PacketCSIWantToStrongerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSIWantToStronger2=pack as PacketCSIWantToStronger2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}