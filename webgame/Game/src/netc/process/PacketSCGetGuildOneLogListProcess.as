package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildOneLogList2;

	public class PacketSCGetGuildOneLogListProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildOneLogListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildOneLogList2=pack as PacketSCGetGuildOneLogList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}