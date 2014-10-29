package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCRefleshNationBeauty2;

	public class PacketSCRefleshNationBeautyProcess extends PacketBaseProcess
	{
		public function PacketSCRefleshNationBeautyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCRefleshNationBeauty2=pack as PacketSCRefleshNationBeauty2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}