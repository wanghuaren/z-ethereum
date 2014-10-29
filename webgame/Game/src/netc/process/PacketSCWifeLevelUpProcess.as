package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCWifeLevelUp2;

	public class PacketSCWifeLevelUpProcess extends PacketBaseProcess
	{
		public function PacketSCWifeLevelUpProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCWifeLevelUp2=pack as PacketSCWifeLevelUp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}