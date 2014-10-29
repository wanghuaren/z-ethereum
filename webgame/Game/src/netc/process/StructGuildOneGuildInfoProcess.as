package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructGuildOneGuildInfo2;

	public class StructGuildOneGuildInfoProcess extends PacketBaseProcess
	{
		public function StructGuildOneGuildInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructGuildOneGuildInfo2=pack as StructGuildOneGuildInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}