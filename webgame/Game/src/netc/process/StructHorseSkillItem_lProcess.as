package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructHorseSkillItem_l2;

	public class StructHorseSkillItem_lProcess extends PacketBaseProcess
	{
		public function StructHorseSkillItem_lProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructHorseSkillItem_l2=pack as StructHorseSkillItem_l2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}