package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSWifeLevelUp2;

	public class PacketCSWifeLevelUpProcess extends PacketBaseProcess
	{
		public function PacketCSWifeLevelUpProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSWifeLevelUp2=pack as PacketCSWifeLevelUp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}