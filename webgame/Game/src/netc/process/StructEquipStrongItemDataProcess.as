package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructEquipStrongItemData2;

	public class StructEquipStrongItemDataProcess extends PacketBaseProcess
	{
		public function StructEquipStrongItemDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructEquipStrongItemData2=pack as StructEquipStrongItemData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}