package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.packets2.PacketSCGetStartPayment2;
	
	public class PacketSCGetStartPaymentProcess extends PacketBaseProcess
	{
		public function PacketSCGetStartPaymentProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetStartPayment2=pack as PacketSCGetStartPayment2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}