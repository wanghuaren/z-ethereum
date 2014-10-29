package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPetCultivateAttr2;

	public class StructPetCultivateAttrProcess extends PacketBaseProcess
	{
		public function StructPetCultivateAttrProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPetCultivateAttr2=pack as StructPetCultivateAttr2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}