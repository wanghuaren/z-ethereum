package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSBuyNewExpLastTime2;

	public class PacketCSBuyNewExpLastTimeProcess extends PacketBaseProcess
	{
		public function PacketCSBuyNewExpLastTimeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSBuyNewExpLastTime2=pack as PacketCSBuyNewExpLastTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}