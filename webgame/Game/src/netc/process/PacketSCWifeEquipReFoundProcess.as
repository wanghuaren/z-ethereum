package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCWifeEquipReFound2;

	public class PacketSCWifeEquipReFoundProcess extends PacketBaseProcess
	{
		public function PacketSCWifeEquipReFoundProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCWifeEquipReFound2=pack as PacketSCWifeEquipReFound2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}