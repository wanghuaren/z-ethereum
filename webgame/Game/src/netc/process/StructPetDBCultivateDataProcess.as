package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPetDBCultivateData2;

	public class StructPetDBCultivateDataProcess extends PacketBaseProcess
	{
		public function StructPetDBCultivateDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPetDBCultivateData2=pack as StructPetDBCultivateData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}