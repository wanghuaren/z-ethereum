package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSHorseFachionUse2;

	public class PacketCSHorseFachionUseProcess extends PacketBaseProcess
	{
		public function PacketCSHorseFachionUseProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSHorseFachionUse2=pack as PacketCSHorseFachionUse2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}