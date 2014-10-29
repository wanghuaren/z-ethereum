package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDiscoveringTreasureInfo2;

	public class PacketSCDiscoveringTreasureInfoProcess extends PacketBaseProcess
	{
		public function PacketSCDiscoveringTreasureInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDiscoveringTreasureInfo2=pack as PacketSCDiscoveringTreasureInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}