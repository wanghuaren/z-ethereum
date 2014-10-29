package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActWeekOnline2;

	public class PacketCSActWeekOnlineProcess extends PacketBaseProcess
	{
		public function PacketCSActWeekOnlineProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActWeekOnline2=pack as PacketCSActWeekOnline2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}