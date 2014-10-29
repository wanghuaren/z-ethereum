package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetDiGongBossState2;

	public class PacketSCGetDiGongBossStateProcess extends PacketBaseProcess
	{
		public function PacketSCGetDiGongBossStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetDiGongBossState2=pack as PacketSCGetDiGongBossState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}