package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildSkillData2;

	public class PacketCSGuildSkillDataProcess extends PacketBaseProcess
	{
		public function PacketCSGuildSkillDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildSkillData2=pack as PacketCSGuildSkillData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}