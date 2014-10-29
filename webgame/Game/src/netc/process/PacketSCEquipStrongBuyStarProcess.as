package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCEquipStrongBuyStar2;

	public class PacketSCEquipStrongBuyStarProcess extends PacketBaseProcess
	{
		public function PacketSCEquipStrongBuyStarProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCEquipStrongBuyStar2=pack as PacketSCEquipStrongBuyStar2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}