package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDiscoveringTreasureLog2;

	public class PacketCSDiscoveringTreasureLogProcess extends PacketBaseProcess
	{
		public function PacketCSDiscoveringTreasureLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDiscoveringTreasureLog2=pack as PacketCSDiscoveringTreasureLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}