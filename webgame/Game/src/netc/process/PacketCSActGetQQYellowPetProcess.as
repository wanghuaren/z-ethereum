package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetQQYellowPet2;

	public class PacketCSActGetQQYellowPetProcess extends PacketBaseProcess
	{
		public function PacketCSActGetQQYellowPetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetQQYellowPet2=pack as PacketCSActGetQQYellowPet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}