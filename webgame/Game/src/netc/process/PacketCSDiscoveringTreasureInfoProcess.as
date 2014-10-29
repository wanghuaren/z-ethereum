package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDiscoveringTreasureInfo2;

	public class PacketCSDiscoveringTreasureInfoProcess extends PacketBaseProcess
	{
		public function PacketCSDiscoveringTreasureInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDiscoveringTreasureInfo2=pack as PacketCSDiscoveringTreasureInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}