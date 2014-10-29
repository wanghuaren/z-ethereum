package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTradeConfirm2;

	public class PacketSCTradeConfirmProcess extends PacketBaseProcess
	{
		public function PacketSCTradeConfirmProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTradeConfirm2=pack as PacketSCTradeConfirm2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}