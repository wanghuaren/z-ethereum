package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSJoinTenMinutes2;

	public class PacketCSJoinTenMinutesProcess extends PacketBaseProcess
	{
		public function PacketCSJoinTenMinutesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSJoinTenMinutes2=pack as PacketCSJoinTenMinutes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}