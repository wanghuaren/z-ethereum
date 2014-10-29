package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPrizeMsgList2;

	public class PacketCSPrizeMsgListProcess extends PacketBaseProcess
	{
		public function PacketCSPrizeMsgListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPrizeMsgList2=pack as PacketCSPrizeMsgList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}