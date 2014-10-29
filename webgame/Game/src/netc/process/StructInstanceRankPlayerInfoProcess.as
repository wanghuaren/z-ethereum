package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructInstanceRankPlayerInfo2;

	public class StructInstanceRankPlayerInfoProcess extends PacketBaseProcess
	{
		public function StructInstanceRankPlayerInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructInstanceRankPlayerInfo2=pack as StructInstanceRankPlayerInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}