package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCWingLevelUp2;

	public class PacketSCWingLevelUpProcess extends PacketBaseProcess
	{
		public function PacketSCWingLevelUpProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCWingLevelUp2=pack as PacketSCWingLevelUp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}