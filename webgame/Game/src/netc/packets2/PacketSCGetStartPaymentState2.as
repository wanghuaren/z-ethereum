package netc.packets2
{
	import common.utils.bit.BitUtil;
	
	import nets.packets.PacketSCGetStartPaymentState;
	
	public class PacketSCGetStartPaymentState2 extends PacketSCGetStartPaymentState
	{
		public function PacketSCGetStartPaymentState2()
		{
			super();
		}
		
		public function get stateArr():Array
		{
			return BitUtil.convertToBinaryArr(this.state);
		}
	}
}