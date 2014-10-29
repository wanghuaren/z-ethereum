package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSMapDoubleExpInfoGet2;

	public class PacketCSMapDoubleExpInfoGetProcess extends PacketBaseProcess
	{
		public function PacketCSMapDoubleExpInfoGetProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSMapDoubleExpInfoGet2=pack as PacketCSMapDoubleExpInfoGet2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}