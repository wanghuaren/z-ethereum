package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSSPKTotalList2;

	public class PacketCSGetSSPKTotalListProcess extends PacketBaseProcess
	{
		public function PacketCSGetSSPKTotalListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSSPKTotalList2=pack as PacketCSGetSSPKTotalList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}