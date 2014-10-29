package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetBitTimeStatus2;

	public class PacketCSGetBitTimeStatusProcess extends PacketBaseProcess
	{
		public function PacketCSGetBitTimeStatusProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetBitTimeStatus2=pack as PacketCSGetBitTimeStatus2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}