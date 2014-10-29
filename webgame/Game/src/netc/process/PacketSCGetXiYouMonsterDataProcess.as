package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;

	import flash.utils.getQualifiedClassName;

	import netc.packets2.PacketSCGetXiYouMonsterData2;

	public class PacketSCGetXiYouMonsterDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetXiYouMonsterDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{

			var p:PacketSCGetXiYouMonsterData2=pack as PacketSCGetXiYouMonsterData2;

			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}


//XiYouXiangMo.monsterData = p;


			return p;
		}
	}
}
