package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipSoulStrong2;

	public class PacketCSEquipSoulStrongProcess extends PacketBaseProcess
	{
		public function PacketCSEquipSoulStrongProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipSoulStrong2=pack as PacketCSEquipSoulStrong2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}