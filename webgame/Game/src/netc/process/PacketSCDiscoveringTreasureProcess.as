package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDiscoveringTreasure2;

	public class PacketSCDiscoveringTreasureProcess extends PacketBaseProcess
	{
		public function PacketSCDiscoveringTreasureProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDiscoveringTreasure2=pack as PacketSCDiscoveringTreasure2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}