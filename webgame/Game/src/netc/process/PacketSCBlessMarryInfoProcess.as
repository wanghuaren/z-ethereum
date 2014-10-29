package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCBlessMarryInfo2;

	public class PacketSCBlessMarryInfoProcess extends PacketBaseProcess
	{
		public function PacketSCBlessMarryInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCBlessMarryInfo2=pack as PacketSCBlessMarryInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}