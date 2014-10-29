package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSimpleLogInfo12;

	public class StructSimpleLogInfo1Process extends PacketBaseProcess
	{
		public function StructSimpleLogInfo1Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSimpleLogInfo12=pack as StructSimpleLogInfo12;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}