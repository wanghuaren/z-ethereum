package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipReFoundActive2;

	public class PacketCSEquipReFoundActiveProcess extends PacketBaseProcess
	{
		public function PacketCSEquipReFoundActiveProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipReFoundActive2=pack as PacketCSEquipReFoundActive2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}