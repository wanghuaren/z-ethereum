package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import nets.*;
	import netc.packets2.PacketSCStudyGeniusSkill2;
	
	public class PacketSCStudyGeniusSkillProcess extends PacketBaseProcess
	{
		public function PacketSCStudyGeniusSkillProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			var p:PacketSCStudyGeniusSkill2 = pack as PacketSCStudyGeniusSkill2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
