package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDrawLuckyItem2;

	public class PacketSCDrawLuckyItemProcess extends PacketBaseProcess
	{
		public function PacketSCDrawLuckyItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDrawLuckyItem2=pack as PacketSCDrawLuckyItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}