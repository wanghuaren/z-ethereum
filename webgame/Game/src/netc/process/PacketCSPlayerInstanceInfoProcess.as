package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPlayerInstanceInfo2;

	public class PacketCSPlayerInstanceInfoProcess extends PacketBaseProcess
	{
		public function PacketCSPlayerInstanceInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPlayerInstanceInfo2=pack as PacketCSPlayerInstanceInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}