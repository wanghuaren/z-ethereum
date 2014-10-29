package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetNationalDayMonsterData2;

	public class PacketSCGetNationalDayMonsterDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetNationalDayMonsterDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetNationalDayMonsterData2=pack as PacketSCGetNationalDayMonsterData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}