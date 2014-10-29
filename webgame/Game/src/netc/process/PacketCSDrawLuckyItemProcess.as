package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDrawLuckyItem2;

	public class PacketCSDrawLuckyItemProcess extends PacketBaseProcess
	{
		public function PacketCSDrawLuckyItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDrawLuckyItem2=pack as PacketCSDrawLuckyItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}