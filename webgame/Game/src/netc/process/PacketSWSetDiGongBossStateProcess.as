package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSWSetDiGongBossState2;

	public class PacketSWSetDiGongBossStateProcess extends PacketBaseProcess
	{
		public function PacketSWSetDiGongBossStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSWSetDiGongBossState2=pack as PacketSWSetDiGongBossState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}