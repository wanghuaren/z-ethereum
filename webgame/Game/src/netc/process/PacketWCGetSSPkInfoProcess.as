package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketWCGetSSPkInfo2;

	public class PacketWCGetSSPkInfoProcess extends PacketBaseProcess
	{
		public function PacketWCGetSSPkInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketWCGetSSPkInfo2=pack as PacketWCGetSSPkInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}