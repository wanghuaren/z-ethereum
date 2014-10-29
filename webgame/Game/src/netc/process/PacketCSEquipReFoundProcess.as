package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipReFound2;

	public class PacketCSEquipReFoundProcess extends PacketBaseProcess
	{
		public function PacketCSEquipReFoundProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipReFound2=pack as PacketCSEquipReFound2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}