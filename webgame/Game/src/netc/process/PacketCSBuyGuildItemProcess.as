package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSBuyGuildItem2;

	public class PacketCSBuyGuildItemProcess extends PacketBaseProcess
	{
		public function PacketCSBuyGuildItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSBuyGuildItem2=pack as PacketCSBuyGuildItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}