package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWGetPlayerPkList2;

	public class PacketCWGetPlayerPkListProcess extends PacketBaseProcess
	{
		public function PacketCWGetPlayerPkListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWGetPlayerPkList2=pack as PacketCWGetPlayerPkList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}