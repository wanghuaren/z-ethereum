package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPetCultivateCD2;

	public class PacketCSPetCultivateCDProcess extends PacketBaseProcess
	{
		public function PacketCSPetCultivateCDProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPetCultivateCD2=pack as PacketCSPetCultivateCD2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}