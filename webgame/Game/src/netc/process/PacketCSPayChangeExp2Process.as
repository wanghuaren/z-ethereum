package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPayChangeExp22;

	public class PacketCSPayChangeExp2Process extends PacketBaseProcess
	{
		public function PacketCSPayChangeExp2Process()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPayChangeExp22=pack as PacketCSPayChangeExp22;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}