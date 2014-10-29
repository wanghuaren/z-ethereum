package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCMergeServerDay2;

	public class PacketSCMergeServerDayProcess extends PacketBaseProcess
	{
		public function PacketSCMergeServerDayProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCMergeServerDay2=pack as PacketSCMergeServerDay2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}