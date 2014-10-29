package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSRefleshNationBeautyResult2;

	public class PacketCSRefleshNationBeautyResultProcess extends PacketBaseProcess
	{
		public function PacketCSRefleshNationBeautyResultProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSRefleshNationBeautyResult2=pack as PacketCSRefleshNationBeautyResult2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}