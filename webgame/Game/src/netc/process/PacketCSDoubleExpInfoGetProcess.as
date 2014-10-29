package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDoubleExpInfoGet2;

	public class PacketCSDoubleExpInfoGetProcess extends PacketBaseProcess
	{
		public function PacketCSDoubleExpInfoGetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDoubleExpInfoGet2=pack as PacketCSDoubleExpInfoGet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}