package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructRankEquipInfo2;

	public class StructRankEquipInfoProcess extends PacketBaseProcess
	{
		public function StructRankEquipInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructRankEquipInfo2=pack as StructRankEquipInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}