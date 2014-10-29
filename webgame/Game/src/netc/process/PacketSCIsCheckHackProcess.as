package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCIsCheckHack2;

	public class PacketSCIsCheckHackProcess extends PacketBaseProcess
	{
		public function PacketSCIsCheckHackProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCIsCheckHack2=pack as PacketSCIsCheckHack2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}