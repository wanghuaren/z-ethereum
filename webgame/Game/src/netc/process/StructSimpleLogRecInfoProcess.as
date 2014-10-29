package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSimpleLogRecInfo2;

	public class StructSimpleLogRecInfoProcess extends PacketBaseProcess
	{
		public function StructSimpleLogRecInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSimpleLogRecInfo2=pack as StructSimpleLogRecInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}