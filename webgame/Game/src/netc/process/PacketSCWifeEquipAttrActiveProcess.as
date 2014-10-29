package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCWifeEquipAttrActive2;

	public class PacketSCWifeEquipAttrActiveProcess extends PacketBaseProcess
	{
		public function PacketSCWifeEquipAttrActiveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCWifeEquipAttrActive2=pack as PacketSCWifeEquipAttrActive2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}