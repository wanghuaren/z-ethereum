package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEquipStrongClear2;

	public class PacketSCEquipStrongClearProcess extends PacketBaseProcess
	{
		public function PacketSCEquipStrongClearProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEquipStrongClear2=pack as PacketSCEquipStrongClear2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}