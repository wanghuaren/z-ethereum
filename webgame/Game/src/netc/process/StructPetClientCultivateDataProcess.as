package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPetClientCultivateData2;

	public class StructPetClientCultivateDataProcess extends PacketBaseProcess
	{
		public function StructPetClientCultivateDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPetClientCultivateData2=pack as StructPetClientCultivateData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}