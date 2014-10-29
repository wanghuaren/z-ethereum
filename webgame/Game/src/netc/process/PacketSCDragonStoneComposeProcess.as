package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCDragonStoneCompose2;

	public class PacketSCDragonStoneComposeProcess extends PacketBaseProcess
	{
		public function PacketSCDragonStoneComposeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCDragonStoneCompose2=pack as PacketSCDragonStoneCompose2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}