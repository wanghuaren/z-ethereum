package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetWorldCupItem2;

	public class PacketCSGetWorldCupItemProcess extends PacketBaseProcess
	{
		public function PacketCSGetWorldCupItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetWorldCupItem2=pack as PacketCSGetWorldCupItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}