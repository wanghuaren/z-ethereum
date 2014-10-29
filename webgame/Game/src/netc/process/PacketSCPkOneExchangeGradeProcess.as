package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCPkOneExchangeGrade2;

	public class PacketSCPkOneExchangeGradeProcess extends PacketBaseProcess
	{
		public function PacketSCPkOneExchangeGradeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCPkOneExchangeGrade2=pack as PacketSCPkOneExchangeGrade2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}