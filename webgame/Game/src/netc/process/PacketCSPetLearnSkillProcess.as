package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPetLearnSkill2;

	public class PacketCSPetLearnSkillProcess extends PacketBaseProcess
	{
		public function PacketCSPetLearnSkillProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPetLearnSkill2=pack as PacketCSPetLearnSkill2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}