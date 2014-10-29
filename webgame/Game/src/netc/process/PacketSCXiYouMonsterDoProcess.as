package netc.process
{
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;

	import flash.utils.getQualifiedClassName;

	import netc.packets2.PacketSCXiYouMonsterDo2;

	public class PacketSCXiYouMonsterDoProcess extends PacketBaseProcess
	{
		public function PacketSCXiYouMonsterDoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{

			var p:PacketSCXiYouMonsterDo2=pack as PacketSCXiYouMonsterDo2;

			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}

			return p;
		}
	}
}
