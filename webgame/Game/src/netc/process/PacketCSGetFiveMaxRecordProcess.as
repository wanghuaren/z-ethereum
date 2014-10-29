package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetFiveMaxRecord2;

	public class PacketCSGetFiveMaxRecordProcess extends PacketBaseProcess
	{
		public function PacketCSGetFiveMaxRecordProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetFiveMaxRecord2=pack as PacketCSGetFiveMaxRecord2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}