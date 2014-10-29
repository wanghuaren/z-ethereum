package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActWeekOnlinePrize2;

	public class PacketCSActWeekOnlinePrizeProcess extends PacketBaseProcess
	{
		public function PacketCSActWeekOnlinePrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActWeekOnlinePrize2=pack as PacketCSActWeekOnlinePrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}