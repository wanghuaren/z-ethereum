package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import netc.packets2.PacketSCGetStartPaymentState2;
	
	public class PacketSCGetStartPaymentStateProcess extends PacketBaseProcess
	{
		public function PacketSCGetStartPaymentStateProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetStartPaymentState2=pack as PacketSCGetStartPaymentState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}