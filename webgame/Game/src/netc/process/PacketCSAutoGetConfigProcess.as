package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSAutoGetConfig2;

	public class PacketCSAutoGetConfigProcess extends PacketBaseProcess
	{
		public function PacketCSAutoGetConfigProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSAutoGetConfig2=pack as PacketCSAutoGetConfig2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}