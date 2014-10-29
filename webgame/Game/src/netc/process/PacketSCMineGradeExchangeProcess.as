package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCMineGradeExchange2;

	public class PacketSCMineGradeExchangeProcess extends PacketBaseProcess
	{
		public function PacketSCMineGradeExchangeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCMineGradeExchange2=pack as PacketSCMineGradeExchange2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}