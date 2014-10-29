package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketSCGetNationBeauty2;

	public class PacketSCGetNationBeautyProcess extends PacketBaseProcess
	{
		public function PacketSCGetNationBeautyProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketSCGetNationBeauty2=pack as PacketSCGetNationBeauty2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}