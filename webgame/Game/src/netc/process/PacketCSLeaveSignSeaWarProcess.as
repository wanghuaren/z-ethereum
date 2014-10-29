package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSLeaveSignSeaWar2;

	public class PacketCSLeaveSignSeaWarProcess extends PacketBaseProcess
	{
		public function PacketCSLeaveSignSeaWarProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSLeaveSignSeaWar2=pack as PacketCSLeaveSignSeaWar2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}