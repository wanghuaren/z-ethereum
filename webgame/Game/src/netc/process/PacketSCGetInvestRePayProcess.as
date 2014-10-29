package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetInvestRePay2;

	public class PacketSCGetInvestRePayProcess extends PacketBaseProcess
	{
		public function PacketSCGetInvestRePayProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetInvestRePay2=pack as PacketSCGetInvestRePay2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}