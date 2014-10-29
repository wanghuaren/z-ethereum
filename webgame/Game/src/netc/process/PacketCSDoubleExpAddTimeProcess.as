package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSDoubleExpAddTime2;

	public class PacketCSDoubleExpAddTimeProcess extends PacketBaseProcess
	{
		public function PacketCSDoubleExpAddTimeProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSDoubleExpAddTime2=pack as PacketCSDoubleExpAddTime2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}