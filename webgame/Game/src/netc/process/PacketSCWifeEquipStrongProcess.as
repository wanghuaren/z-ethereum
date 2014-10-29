package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCWifeEquipStrong2;

	public class PacketSCWifeEquipStrongProcess extends PacketBaseProcess
	{
		public function PacketSCWifeEquipStrongProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCWifeEquipStrong2=pack as PacketSCWifeEquipStrong2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}