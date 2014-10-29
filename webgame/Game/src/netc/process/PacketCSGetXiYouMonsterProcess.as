package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetXiYouMonster2;

	public class PacketCSGetXiYouMonsterProcess extends PacketBaseProcess
	{
		public function PacketCSGetXiYouMonsterProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetXiYouMonster2=pack as PacketCSGetXiYouMonster2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}