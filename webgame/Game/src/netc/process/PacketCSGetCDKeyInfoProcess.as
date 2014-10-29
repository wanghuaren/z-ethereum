package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetCDKeyInfo2;

	public class PacketCSGetCDKeyInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetCDKeyInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetCDKeyInfo2=pack as PacketCSGetCDKeyInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}