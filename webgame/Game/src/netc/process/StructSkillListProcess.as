package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSkillList2;

	public class StructSkillListProcess extends PacketBaseProcess
	{
		public function StructSkillListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSkillList2=pack as StructSkillList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}