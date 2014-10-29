package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSSPKRankUserInfo2;

	public class StructSSPKRankUserInfoProcess extends PacketBaseProcess
	{
		public function StructSSPKRankUserInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSSPKRankUserInfo2=pack as StructSSPKRankUserInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}