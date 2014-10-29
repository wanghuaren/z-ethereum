package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPetDBCultivateCD2;

	public class StructPetDBCultivateCDProcess extends PacketBaseProcess
	{
		public function StructPetDBCultivateCDProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPetDBCultivateCD2=pack as StructPetDBCultivateCD2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}