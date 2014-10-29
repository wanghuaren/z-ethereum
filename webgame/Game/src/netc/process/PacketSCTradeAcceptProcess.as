package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCTradeAccept2;

	public class PacketSCTradeAcceptProcess extends PacketBaseProcess
	{
		public function PacketSCTradeAcceptProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCTradeAccept2=pack as PacketSCTradeAccept2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}