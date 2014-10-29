package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetSSPKResult2;

	public class PacketSCGetSSPKResultProcess extends PacketBaseProcess
	{
		public function PacketSCGetSSPKResultProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetSSPKResult2=pack as PacketSCGetSSPKResult2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}