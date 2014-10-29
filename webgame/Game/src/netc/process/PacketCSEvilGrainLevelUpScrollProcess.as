package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSEvilGrainLevelUpScroll2;

	public class PacketCSEvilGrainLevelUpScrollProcess extends PacketBaseProcess
	{
		public function PacketCSEvilGrainLevelUpScrollProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSEvilGrainLevelUpScroll2=pack as PacketCSEvilGrainLevelUpScroll2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}