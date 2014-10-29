package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetQQYellowPrizeToBag2;

	public class PacketCSActGetQQYellowPrizeToBagProcess extends PacketBaseProcess
	{
		public function PacketCSActGetQQYellowPrizeToBagProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetQQYellowPrizeToBag2=pack as PacketCSActGetQQYellowPrizeToBag2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}