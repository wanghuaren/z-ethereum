package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import nets.*;
	import netc.packets2.PacketSCResetGeniusSkill2;
	
	public class PacketSCResetGeniusSkillProcess extends PacketBaseProcess
	{
		public function PacketSCResetGeniusSkillProcess()
		{
			super();
		}
		
		override public function process(pack:IPacket):IPacket
		{
			
			var p:PacketSCResetGeniusSkill2 = pack as PacketSCResetGeniusSkill2;
			
			if(null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			
			return p;
		}
	}
}
