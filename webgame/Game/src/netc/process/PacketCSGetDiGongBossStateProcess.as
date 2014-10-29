package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetDiGongBossState2;

	public class PacketCSGetDiGongBossStateProcess extends PacketBaseProcess
	{
		public function PacketCSGetDiGongBossStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetDiGongBossState2=pack as PacketCSGetDiGongBossState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}