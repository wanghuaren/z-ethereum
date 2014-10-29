package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWGetSSPkInfo2;

	public class PacketCWGetSSPkInfoProcess extends PacketBaseProcess
	{
		public function PacketCWGetSSPkInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWGetSSPkInfo2=pack as PacketCWGetSSPkInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}