package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetServerPKResult2;

	public class PacketCSGetServerPKResultProcess extends PacketBaseProcess
	{
		public function PacketCSGetServerPKResultProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetServerPKResult2=pack as PacketCSGetServerPKResult2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}