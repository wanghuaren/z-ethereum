package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetDiscoveringTreasure2;

	public class PacketCSActGetDiscoveringTreasureProcess extends PacketBaseProcess
	{
		public function PacketCSActGetDiscoveringTreasureProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetDiscoveringTreasure2=pack as PacketCSActGetDiscoveringTreasure2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}