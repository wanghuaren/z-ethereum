package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructEquipStrongItem2;

	public class StructEquipStrongItemProcess extends PacketBaseProcess
	{
		public function StructEquipStrongItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructEquipStrongItem2=pack as StructEquipStrongItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}