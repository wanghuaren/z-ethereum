package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSActGetHeroBeautyData2;

	public class PacketCSActGetHeroBeautyDataProcess extends PacketBaseProcess
	{
		public function PacketCSActGetHeroBeautyDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSActGetHeroBeautyData2=pack as PacketCSActGetHeroBeautyData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}