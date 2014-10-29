package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSRefleshNationBeauty2;

	public class PacketCSRefleshNationBeautyProcess extends PacketBaseProcess
	{
		public function PacketCSRefleshNationBeautyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSRefleshNationBeauty2=pack as PacketCSRefleshNationBeauty2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}