package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetInvestRePay2;

	public class PacketCSGetInvestRePayProcess extends PacketBaseProcess
	{
		public function PacketCSGetInvestRePayProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetInvestRePay2=pack as PacketCSGetInvestRePay2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}