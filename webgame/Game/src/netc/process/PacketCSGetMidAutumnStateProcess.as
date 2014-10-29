package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetMidAutumnState2;

	public class PacketCSGetMidAutumnStateProcess extends PacketBaseProcess
	{
		public function PacketCSGetMidAutumnStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetMidAutumnState2=pack as PacketCSGetMidAutumnState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}