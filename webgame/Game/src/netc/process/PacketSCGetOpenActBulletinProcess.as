package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetOpenActBulletin2;

	public class PacketSCGetOpenActBulletinProcess extends PacketBaseProcess
	{
		public function PacketSCGetOpenActBulletinProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetOpenActBulletin2=pack as PacketSCGetOpenActBulletin2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}