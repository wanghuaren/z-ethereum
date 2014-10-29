package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetWifeValueInfo2;

	public class PacketCSGetWifeValueInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetWifeValueInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetWifeValueInfo2=pack as PacketCSGetWifeValueInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}