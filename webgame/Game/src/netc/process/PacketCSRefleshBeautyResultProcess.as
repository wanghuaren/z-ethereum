package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSRefleshBeautyResult2;

	public class PacketCSRefleshBeautyResultProcess extends PacketBaseProcess
	{
		public function PacketCSRefleshBeautyResultProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSRefleshBeautyResult2=pack as PacketCSRefleshBeautyResult2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}