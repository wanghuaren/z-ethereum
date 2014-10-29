package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSServerTitleWinerName2;

	public class PacketCSServerTitleWinerNameProcess extends PacketBaseProcess
	{
		public function PacketCSServerTitleWinerNameProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSServerTitleWinerName2=pack as PacketCSServerTitleWinerName2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}