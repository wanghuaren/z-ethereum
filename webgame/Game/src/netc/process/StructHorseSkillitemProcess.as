package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructHorseSkillitem2;

	public class StructHorseSkillitemProcess extends PacketBaseProcess
	{
		public function StructHorseSkillitemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructHorseSkillitem2=pack as StructHorseSkillitem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}