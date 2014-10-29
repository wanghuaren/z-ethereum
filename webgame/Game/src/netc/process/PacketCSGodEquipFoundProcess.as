package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGodEquipFound2;

	public class PacketCSGodEquipFoundProcess extends PacketBaseProcess
	{
		public function PacketCSGodEquipFoundProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGodEquipFound2=pack as PacketCSGodEquipFound2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}