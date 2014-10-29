package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCBuyGuildGuard2;

	public class PacketSCBuyGuildGuardProcess extends PacketBaseProcess
	{
		public function PacketSCBuyGuildGuardProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCBuyGuildGuard2=pack as PacketSCBuyGuildGuard2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}