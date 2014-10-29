package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSQuerySkillInfo2;

	public class PacketCSQuerySkillInfoProcess extends PacketBaseProcess
	{
		public function PacketCSQuerySkillInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSQuerySkillInfo2=pack as PacketCSQuerySkillInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}