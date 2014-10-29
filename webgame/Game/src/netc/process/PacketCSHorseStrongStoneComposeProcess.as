package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSHorseStrongStoneCompose2;

	public class PacketCSHorseStrongStoneComposeProcess extends PacketBaseProcess
	{
		public function PacketCSHorseStrongStoneComposeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSHorseStrongStoneCompose2=pack as PacketCSHorseStrongStoneCompose2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}