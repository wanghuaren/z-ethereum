package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSGetNationBeauty2;

	public class PacketCSGetNationBeautyProcess extends PacketBaseProcess
	{
		public function PacketCSGetNationBeautyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSGetNationBeauty2=pack as PacketCSGetNationBeauty2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}