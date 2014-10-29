package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetGuildArea1PrizeInfo2;

	public class PacketCSGetGuildArea1PrizeInfoProcess extends PacketBaseProcess
	{
		public function PacketCSGetGuildArea1PrizeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetGuildArea1PrizeInfo2=pack as PacketCSGetGuildArea1PrizeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}