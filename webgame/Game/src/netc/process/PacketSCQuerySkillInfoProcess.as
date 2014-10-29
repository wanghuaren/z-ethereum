package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	
	import flash.utils.getQualifiedClassName;
	
	import netc.Data;
	import netc.packets2.PacketSCQuerySkillInfo2;

	public class PacketSCQuerySkillInfoProcess extends PacketBaseProcess
	{
		public function PacketSCQuerySkillInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCQuerySkillInfo2=pack as PacketSCQuerySkillInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			Data.skill.updExp(p.skillitem.skillId,p.skillitem.skillExp);
				
			return p;
		}
	}
}