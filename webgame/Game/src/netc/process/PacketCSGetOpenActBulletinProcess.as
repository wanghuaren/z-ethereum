package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetOpenActBulletin2;

	public class PacketCSGetOpenActBulletinProcess extends PacketBaseProcess
	{
		public function PacketCSGetOpenActBulletinProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetOpenActBulletin2=pack as PacketCSGetOpenActBulletin2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}