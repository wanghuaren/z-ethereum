package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSWifeEquipAttrActive2;

	public class PacketCSWifeEquipAttrActiveProcess extends PacketBaseProcess
	{
		public function PacketCSWifeEquipAttrActiveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSWifeEquipAttrActive2=pack as PacketCSWifeEquipAttrActive2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}