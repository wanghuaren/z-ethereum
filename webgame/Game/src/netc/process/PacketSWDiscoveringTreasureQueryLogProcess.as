package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSWDiscoveringTreasureQueryLog2;

	public class PacketSWDiscoveringTreasureQueryLogProcess extends PacketBaseProcess
	{
		public function PacketSWDiscoveringTreasureQueryLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSWDiscoveringTreasureQueryLog2=pack as PacketSWDiscoveringTreasureQueryLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}