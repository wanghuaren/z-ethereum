package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSUnEquipHoreseSkill2;

	public class PacketCSUnEquipHoreseSkillProcess extends PacketBaseProcess
	{
		public function PacketCSUnEquipHoreseSkillProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSUnEquipHoreseSkill2=pack as PacketCSUnEquipHoreseSkill2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}