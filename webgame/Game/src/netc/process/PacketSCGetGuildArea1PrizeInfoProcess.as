package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetGuildArea1PrizeInfo2;

	public class PacketSCGetGuildArea1PrizeInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetGuildArea1PrizeInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetGuildArea1PrizeInfo2=pack as PacketSCGetGuildArea1PrizeInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}