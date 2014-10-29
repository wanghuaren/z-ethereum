package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetGuildOneLogList2;

	public class PacketCSGetGuildOneLogListProcess extends PacketBaseProcess
	{
		public function PacketCSGetGuildOneLogListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetGuildOneLogList2=pack as PacketCSGetGuildOneLogList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}