package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructDiGongBossState2;

	public class StructDiGongBossStateProcess extends PacketBaseProcess
	{
		public function StructDiGongBossStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructDiGongBossState2=pack as StructDiGongBossState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}