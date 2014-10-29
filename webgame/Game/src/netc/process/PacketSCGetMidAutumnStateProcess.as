package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetMidAutumnState2;

	public class PacketSCGetMidAutumnStateProcess extends PacketBaseProcess
	{
		public function PacketSCGetMidAutumnStateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetMidAutumnState2=pack as PacketSCGetMidAutumnState2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}