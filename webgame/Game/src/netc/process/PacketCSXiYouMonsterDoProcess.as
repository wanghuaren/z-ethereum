package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSXiYouMonsterDo2;

	public class PacketCSXiYouMonsterDoProcess extends PacketBaseProcess
	{
		public function PacketCSXiYouMonsterDoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSXiYouMonsterDo2=pack as PacketCSXiYouMonsterDo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}