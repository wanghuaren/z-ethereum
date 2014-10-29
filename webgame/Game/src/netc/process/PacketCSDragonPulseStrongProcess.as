package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDragonPulseStrong2;

	public class PacketCSDragonPulseStrongProcess extends PacketBaseProcess
	{
		public function PacketCSDragonPulseStrongProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDragonPulseStrong2=pack as PacketCSDragonPulseStrong2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}