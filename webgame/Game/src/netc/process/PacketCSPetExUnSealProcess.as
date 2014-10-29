package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPetExUnSeal2;

	public class PacketCSPetExUnSealProcess extends PacketBaseProcess
	{
		public function PacketCSPetExUnSealProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPetExUnSeal2=pack as PacketCSPetExUnSeal2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}