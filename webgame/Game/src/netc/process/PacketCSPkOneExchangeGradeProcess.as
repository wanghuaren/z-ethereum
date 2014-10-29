package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPkOneExchangeGrade2;

	public class PacketCSPkOneExchangeGradeProcess extends PacketBaseProcess
	{
		public function PacketCSPkOneExchangeGradeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPkOneExchangeGrade2=pack as PacketCSPkOneExchangeGrade2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}