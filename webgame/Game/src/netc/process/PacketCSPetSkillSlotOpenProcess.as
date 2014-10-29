package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPetSkillSlotOpen2;

	public class PacketCSPetSkillSlotOpenProcess extends PacketBaseProcess
	{
		public function PacketCSPetSkillSlotOpenProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPetSkillSlotOpen2=pack as PacketCSPetSkillSlotOpen2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}