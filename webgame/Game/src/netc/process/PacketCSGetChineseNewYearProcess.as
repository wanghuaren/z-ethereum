package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetChineseNewYear2;

	public class PacketCSGetChineseNewYearProcess extends PacketBaseProcess
	{
		public function PacketCSGetChineseNewYearProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetChineseNewYear2=pack as PacketCSGetChineseNewYear2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}