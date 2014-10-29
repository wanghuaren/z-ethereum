package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetQQYellowPrize2;

	public class PacketCSActGetQQYellowPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSActGetQQYellowPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetQQYellowPrize2=pack as PacketCSActGetQQYellowPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}