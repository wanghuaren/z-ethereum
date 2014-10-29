package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEvilGrainLevelUp2;

	public class PacketCSEvilGrainLevelUpProcess extends PacketBaseProcess
	{
		public function PacketCSEvilGrainLevelUpProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEvilGrainLevelUp2=pack as PacketCSEvilGrainLevelUp2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}