package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetVipLevelData2;

	public class PacketCSGetVipLevelDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetVipLevelDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetVipLevelData2=pack as PacketCSGetVipLevelData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}