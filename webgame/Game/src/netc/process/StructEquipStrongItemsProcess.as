package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructEquipStrongItems2;

	public class StructEquipStrongItemsProcess extends PacketBaseProcess
	{
		public function StructEquipStrongItemsProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructEquipStrongItems2=pack as StructEquipStrongItems2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}