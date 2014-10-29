package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipStrongClear2;

	public class PacketCSEquipStrongClearProcess extends PacketBaseProcess
	{
		public function PacketCSEquipStrongClearProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipStrongClear2=pack as PacketCSEquipStrongClear2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}