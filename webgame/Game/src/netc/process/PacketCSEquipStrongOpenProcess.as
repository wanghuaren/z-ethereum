package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipStrongOpen2;

	public class PacketCSEquipStrongOpenProcess extends PacketBaseProcess
	{
		public function PacketCSEquipStrongOpenProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipStrongOpen2=pack as PacketCSEquipStrongOpen2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}