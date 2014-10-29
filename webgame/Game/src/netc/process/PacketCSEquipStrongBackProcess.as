package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipStrongBack2;

	public class PacketCSEquipStrongBackProcess extends PacketBaseProcess
	{
		public function PacketCSEquipStrongBackProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipStrongBack2=pack as PacketCSEquipStrongBack2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}