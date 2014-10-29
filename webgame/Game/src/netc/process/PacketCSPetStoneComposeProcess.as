package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPetStoneCompose2;

	public class PacketCSPetStoneComposeProcess extends PacketBaseProcess
	{
		public function PacketCSPetStoneComposeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPetStoneCompose2=pack as PacketCSPetStoneCompose2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}