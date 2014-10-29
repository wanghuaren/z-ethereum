package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerLeaveInstance2;

	public class PacketCSPlayerLeaveInstanceProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerLeaveInstanceProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerLeaveInstance2=pack as PacketCSPlayerLeaveInstance2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}