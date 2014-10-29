package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSHorseFachionUnUse2;

	public class PacketCSHorseFachionUnUseProcess extends PacketBaseProcess
	{
		public function PacketCSHorseFachionUnUseProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSHorseFachionUnUse2=pack as PacketCSHorseFachionUnUse2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}