package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDiGongBossAppear2;

	public class PacketSCDiGongBossAppearProcess extends PacketBaseProcess
	{
		public function PacketSCDiGongBossAppearProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDiGongBossAppear2=pack as PacketSCDiGongBossAppear2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}