package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCJoinTenMinutes2;

	public class PacketSCJoinTenMinutesProcess extends PacketBaseProcess
	{
		public function PacketSCJoinTenMinutesProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCJoinTenMinutes2=pack as PacketSCJoinTenMinutes2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}