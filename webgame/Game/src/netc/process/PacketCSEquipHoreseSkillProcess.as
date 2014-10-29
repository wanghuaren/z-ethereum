package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEquipHoreseSkill2;

	public class PacketCSEquipHoreseSkillProcess extends PacketBaseProcess
	{
		public function PacketCSEquipHoreseSkillProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEquipHoreseSkill2=pack as PacketCSEquipHoreseSkill2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}