package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDiscoveringTreasureLog2;

	public class PacketSCDiscoveringTreasureLogProcess extends PacketBaseProcess
	{
		public function PacketSCDiscoveringTreasureLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDiscoveringTreasureLog2=pack as PacketSCDiscoveringTreasureLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}