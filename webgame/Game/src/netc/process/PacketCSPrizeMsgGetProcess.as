package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPrizeMsgGet2;

	public class PacketCSPrizeMsgGetProcess extends PacketBaseProcess
	{
		public function PacketCSPrizeMsgGetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPrizeMsgGet2=pack as PacketCSPrizeMsgGet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}