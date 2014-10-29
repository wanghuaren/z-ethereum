package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetMidAutumnData2;

	public class PacketCSGetMidAutumnDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetMidAutumnDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetMidAutumnData2=pack as PacketCSGetMidAutumnData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}