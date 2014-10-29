package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetHoreseSkill2;

	public class PacketCSGetHoreseSkillProcess extends PacketBaseProcess
	{
		public function PacketCSGetHoreseSkillProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetHoreseSkill2=pack as PacketCSGetHoreseSkill2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}