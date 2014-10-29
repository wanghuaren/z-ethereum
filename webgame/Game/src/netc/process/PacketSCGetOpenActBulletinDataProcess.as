package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetOpenActBulletinData2;

	public class PacketSCGetOpenActBulletinDataProcess extends PacketBaseProcess
	{
		public function PacketSCGetOpenActBulletinDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetOpenActBulletinData2=pack as PacketSCGetOpenActBulletinData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}