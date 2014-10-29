package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetXiYouMonsterData2;

	public class PacketCSGetXiYouMonsterDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetXiYouMonsterDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetXiYouMonsterData2=pack as PacketCSGetXiYouMonsterData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}