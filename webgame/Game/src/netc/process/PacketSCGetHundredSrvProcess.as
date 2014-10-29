package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetHundredSrv2;

	public class PacketSCGetHundredSrvProcess extends PacketBaseProcess
	{
		public function PacketSCGetHundredSrvProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetHundredSrv2=pack as PacketSCGetHundredSrv2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}