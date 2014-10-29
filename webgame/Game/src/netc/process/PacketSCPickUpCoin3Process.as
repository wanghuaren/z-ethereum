package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCPickUpCoin32;

	public class PacketSCPickUpCoin3Process extends PacketBaseProcess
	{
		public function PacketSCPickUpCoin3Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCPickUpCoin32=pack as PacketSCPickUpCoin32;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}