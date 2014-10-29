package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSResetGeniusSkill2;

	public class PacketCSResetGeniusSkillProcess extends PacketBaseProcess
	{
		public function PacketCSResetGeniusSkillProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSResetGeniusSkill2=pack as PacketCSResetGeniusSkill2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}