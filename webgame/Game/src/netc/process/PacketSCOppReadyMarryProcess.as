package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCOppReadyMarry2;

	public class PacketSCOppReadyMarryProcess extends PacketBaseProcess
	{
		public function PacketSCOppReadyMarryProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCOppReadyMarry2=pack as PacketSCOppReadyMarry2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}