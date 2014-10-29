package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetHundredSrvData2;

	public class PacketSCGetHundredSrvDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetHundredSrvDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetHundredSrvData2=pack as PacketSCGetHundredSrvData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}