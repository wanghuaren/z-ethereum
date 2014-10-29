package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetSSPKSign2;

	public class PacketCSGetSSPKSignProcess extends PacketBaseProcess
	{
		public function PacketCSGetSSPKSignProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetSSPKSign2=pack as PacketCSGetSSPKSign2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}