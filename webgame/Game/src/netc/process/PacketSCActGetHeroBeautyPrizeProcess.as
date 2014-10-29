package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCActGetHeroBeautyPrize2;

	public class PacketSCActGetHeroBeautyPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCActGetHeroBeautyPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCActGetHeroBeautyPrize2=pack as PacketSCActGetHeroBeautyPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}