package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGuildBossPrizeAssign2;

	public class PacketCSGuildBossPrizeAssignProcess extends PacketBaseProcess
	{
		public function PacketCSGuildBossPrizeAssignProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGuildBossPrizeAssign2=pack as PacketCSGuildBossPrizeAssign2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}