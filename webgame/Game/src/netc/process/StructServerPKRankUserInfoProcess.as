package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructServerPKRankUserInfo2;

	public class StructServerPKRankUserInfoProcess extends PacketBaseProcess
	{
		public function StructServerPKRankUserInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructServerPKRankUserInfo2=pack as StructServerPKRankUserInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}