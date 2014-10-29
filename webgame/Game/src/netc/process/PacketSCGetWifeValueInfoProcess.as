package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetWifeValueInfo2;

	public class PacketSCGetWifeValueInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetWifeValueInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetWifeValueInfo2=pack as PacketSCGetWifeValueInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}