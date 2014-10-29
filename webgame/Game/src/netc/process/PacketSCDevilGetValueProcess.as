package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDevilGetValue2;

	public class PacketSCDevilGetValueProcess extends PacketBaseProcess
	{
		public function PacketSCDevilGetValueProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDevilGetValue2=pack as PacketSCDevilGetValue2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}