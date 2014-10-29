package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWSDelVirtualPlayer2;

	public class PacketWSDelVirtualPlayerProcess extends PacketBaseProcess
	{
		public function PacketWSDelVirtualPlayerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWSDelVirtualPlayer2=pack as PacketWSDelVirtualPlayer2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}