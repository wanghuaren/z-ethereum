package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSWifeEquipReFound2;

	public class PacketCSWifeEquipReFoundProcess extends PacketBaseProcess
	{
		public function PacketCSWifeEquipReFoundProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSWifeEquipReFound2=pack as PacketCSWifeEquipReFound2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}