package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSLearnHoreseSkill2;

	public class PacketCSLearnHoreseSkillProcess extends PacketBaseProcess
	{
		public function PacketCSLearnHoreseSkillProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSLearnHoreseSkill2=pack as PacketCSLearnHoreseSkill2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}