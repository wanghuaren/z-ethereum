package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSHorseStarStoneCompose2;

	public class PacketCSHorseStarStoneComposeProcess extends PacketBaseProcess
	{
		public function PacketCSHorseStarStoneComposeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSHorseStarStoneCompose2=pack as PacketCSHorseStarStoneCompose2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}