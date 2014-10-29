package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetSSPKSelfInfo2;

	public class PacketSCGetSSPKSelfInfoProcess extends PacketBaseProcess
	{
		public function PacketSCGetSSPKSelfInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSSPKSelfInfo2=pack as PacketSCGetSSPKSelfInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}