package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSResetStrongTimeCoin2;

	public class PacketCSResetStrongTimeCoinProcess extends PacketBaseProcess
	{
		public function PacketCSResetStrongTimeCoinProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSResetStrongTimeCoin2=pack as PacketCSResetStrongTimeCoin2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}