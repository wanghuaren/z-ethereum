package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetHeroBeautyPrize2;

	public class PacketCSActGetHeroBeautyPrizeProcess extends PacketBaseProcess
	{
		public function PacketCSActGetHeroBeautyPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetHeroBeautyPrize2=pack as PacketCSActGetHeroBeautyPrize2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}