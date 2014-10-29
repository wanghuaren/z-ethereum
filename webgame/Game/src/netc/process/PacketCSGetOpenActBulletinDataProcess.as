package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetOpenActBulletinData2;

	public class PacketCSGetOpenActBulletinDataProcess extends PacketBaseProcess
	{
		public function PacketCSGetOpenActBulletinDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetOpenActBulletinData2=pack as PacketCSGetOpenActBulletinData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}