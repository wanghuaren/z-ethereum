package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructWSMonitorSamplingData2;

	public class StructWSMonitorSamplingDataProcess extends PacketBaseProcess
	{
		public function StructWSMonitorSamplingDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructWSMonitorSamplingData2=pack as StructWSMonitorSamplingData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}