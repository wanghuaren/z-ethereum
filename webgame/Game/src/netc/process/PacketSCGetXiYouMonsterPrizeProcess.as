package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;

	import flash.utils.getQualifiedClassName;

	import netc.packets2.PacketSCGetXiYouMonsterPrize2;

	public class PacketSCGetXiYouMonsterPrizeProcess extends PacketBaseProcess
	{
		public function PacketSCGetXiYouMonsterPrizeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{

			var p:PacketSCGetXiYouMonsterPrize2=pack as PacketSCGetXiYouMonsterPrize2;

			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}

//XiYouXiangMo.monsterPrize = p;

			return p;
		}
	}
}
