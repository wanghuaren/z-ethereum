package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCRefleshNationBeautyResult2;

	public class PacketSCRefleshNationBeautyResultProcess extends PacketBaseProcess
	{
		public function PacketSCRefleshNationBeautyResultProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCRefleshNationBeautyResult2=pack as PacketSCRefleshNationBeautyResult2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}