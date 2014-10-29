package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructRequestLimit2;

	public class StructRequestLimitProcess extends PacketBaseProcess
	{
		public function StructRequestLimitProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructRequestLimit2=pack as StructRequestLimit2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}