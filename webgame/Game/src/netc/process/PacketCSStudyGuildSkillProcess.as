package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSStudyGuildSkill2;

	public class PacketCSStudyGuildSkillProcess extends PacketBaseProcess
	{
		public function PacketCSStudyGuildSkillProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSStudyGuildSkill2=pack as PacketCSStudyGuildSkill2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}