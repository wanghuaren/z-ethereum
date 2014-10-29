package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetNewExpLastTime2;

	public class PacketCSGetNewExpLastTimeProcess extends PacketBaseProcess
	{
		public function PacketCSGetNewExpLastTimeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetNewExpLastTime2=pack as PacketCSGetNewExpLastTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}