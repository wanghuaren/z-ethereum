package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSAutoGetTime2;

	public class PacketCSAutoGetTimeProcess extends PacketBaseProcess
	{
		public function PacketCSAutoGetTimeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSAutoGetTime2=pack as PacketCSAutoGetTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}