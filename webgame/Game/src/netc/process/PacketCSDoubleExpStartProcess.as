package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDoubleExpStart2;

	public class PacketCSDoubleExpStartProcess extends PacketBaseProcess
	{
		public function PacketCSDoubleExpStartProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDoubleExpStart2=pack as PacketCSDoubleExpStart2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}