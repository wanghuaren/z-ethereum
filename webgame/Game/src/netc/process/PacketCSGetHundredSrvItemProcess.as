package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetHundredSrvItem2;

	public class PacketCSGetHundredSrvItemProcess extends PacketBaseProcess
	{
		public function PacketCSGetHundredSrvItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetHundredSrvItem2=pack as PacketCSGetHundredSrvItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}