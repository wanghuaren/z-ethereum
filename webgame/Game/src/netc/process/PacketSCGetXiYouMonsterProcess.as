package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;

	import flash.utils.getQualifiedClassName;

	import netc.packets2.PacketSCGetXiYouMonster2;

	public class PacketSCGetXiYouMonsterProcess extends PacketBaseProcess
	{
		public function PacketSCGetXiYouMonsterProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{

			var p:PacketSCGetXiYouMonster2=pack as PacketSCGetXiYouMonster2;

			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}

//XiYouXiangMo.begin_date = p.begin_date;
//XiYouXiangMo.end_date = p.end_date;
//XiYouXiangMo.state = p.state;

			return p;
		}
	}
}
