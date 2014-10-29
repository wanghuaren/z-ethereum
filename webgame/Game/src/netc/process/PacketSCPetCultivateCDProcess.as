package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCPetCultivateCD2;

	public class PacketSCPetCultivateCDProcess extends PacketBaseProcess
	{
		public function PacketSCPetCultivateCDProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCPetCultivateCD2=pack as PacketSCPetCultivateCD2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}