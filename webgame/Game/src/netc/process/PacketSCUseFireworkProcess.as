package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCUseFirework2;

	public class PacketSCUseFireworkProcess extends PacketBaseProcess
	{
		public function PacketSCUseFireworkProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCUseFirework2=pack as PacketSCUseFirework2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}