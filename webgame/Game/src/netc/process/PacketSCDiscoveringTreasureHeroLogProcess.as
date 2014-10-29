package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDiscoveringTreasureHeroLog2;

	public class PacketSCDiscoveringTreasureHeroLogProcess extends PacketBaseProcess
	{
		public function PacketSCDiscoveringTreasureHeroLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDiscoveringTreasureHeroLog2=pack as PacketSCDiscoveringTreasureHeroLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}