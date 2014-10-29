package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActiveGuildSkill2;

	public class PacketCSActiveGuildSkillProcess extends PacketBaseProcess
	{
		public function PacketCSActiveGuildSkillProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActiveGuildSkill2=pack as PacketCSActiveGuildSkill2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}