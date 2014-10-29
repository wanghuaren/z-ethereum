package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSCloseActIds2;

	public class PacketCSCloseActIdsProcess extends PacketBaseProcess
	{
		public function PacketCSCloseActIdsProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSCloseActIds2=pack as PacketCSCloseActIds2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}