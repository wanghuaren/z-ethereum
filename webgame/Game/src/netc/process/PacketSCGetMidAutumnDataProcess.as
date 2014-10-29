package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetMidAutumnData2;

	public class PacketSCGetMidAutumnDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetMidAutumnDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetMidAutumnData2=pack as PacketSCGetMidAutumnData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}