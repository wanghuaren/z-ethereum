package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSHorseSkillAddPos2;

	public class PacketCSHorseSkillAddPosProcess extends PacketBaseProcess
	{
		public function PacketCSHorseSkillAddPosProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSHorseSkillAddPos2=pack as PacketCSHorseSkillAddPos2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}