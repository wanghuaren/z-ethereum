package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDiscoveringTreasure2;

	public class PacketCSDiscoveringTreasureProcess extends PacketBaseProcess
	{
		public function PacketCSDiscoveringTreasureProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDiscoveringTreasure2=pack as PacketCSDiscoveringTreasure2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}