package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSTradeConfirm2;

	public class PacketCSTradeConfirmProcess extends PacketBaseProcess
	{
		public function PacketCSTradeConfirmProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSTradeConfirm2=pack as PacketCSTradeConfirm2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}