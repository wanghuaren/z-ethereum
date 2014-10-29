package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetWorldLevel2;

	public class PacketCSGetWorldLevelProcess extends PacketBaseProcess
	{
		public function PacketCSGetWorldLevelProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetWorldLevel2=pack as PacketCSGetWorldLevel2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}