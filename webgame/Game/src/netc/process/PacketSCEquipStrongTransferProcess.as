package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEquipStrongTransfer2;

	public class PacketSCEquipStrongTransferProcess extends PacketBaseProcess
	{
		public function PacketSCEquipStrongTransferProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEquipStrongTransfer2=pack as PacketSCEquipStrongTransfer2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}