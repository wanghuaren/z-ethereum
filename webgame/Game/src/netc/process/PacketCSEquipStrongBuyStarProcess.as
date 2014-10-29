package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipStrongBuyStar2;

	public class PacketCSEquipStrongBuyStarProcess extends PacketBaseProcess
	{
		public function PacketCSEquipStrongBuyStarProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipStrongBuyStar2=pack as PacketCSEquipStrongBuyStar2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}