package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetStartPrizeState2;

	public class PacketCSGetStartPrizeStateProcess extends PacketBaseProcess
	{
		public function PacketCSGetStartPrizeStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetStartPrizeState2=pack as PacketCSGetStartPrizeState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}