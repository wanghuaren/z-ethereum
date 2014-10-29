package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPetClientCultivateCD2;

	public class StructPetClientCultivateCDProcess extends PacketBaseProcess
	{
		public function StructPetClientCultivateCDProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPetClientCultivateCD2=pack as StructPetClientCultivateCD2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}