package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPetAddUnSealCount2;

	public class PacketCSPetAddUnSealCountProcess extends PacketBaseProcess
	{
		public function PacketCSPetAddUnSealCountProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPetAddUnSealCount2=pack as PacketCSPetAddUnSealCount2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}