package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetBitTimeStatus2;

	public class PacketSCGetBitTimeStatusProcess extends PacketBaseProcess
	{
		public function PacketSCGetBitTimeStatusProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetBitTimeStatus2=pack as PacketSCGetBitTimeStatus2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}