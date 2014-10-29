package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructTreasureGoodsInfo2;

	public class StructTreasureGoodsInfoProcess extends PacketBaseProcess
	{
		public function StructTreasureGoodsInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructTreasureGoodsInfo2=pack as StructTreasureGoodsInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}