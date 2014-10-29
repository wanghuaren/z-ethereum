package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetNationalDayMonsterData2;

	public class PacketCSGetNationalDayMonsterDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetNationalDayMonsterDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetNationalDayMonsterData2=pack as PacketCSGetNationalDayMonsterData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}