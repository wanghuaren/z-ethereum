package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSBoothLeaveWord2;

	public class PacketCSBoothLeaveWordProcess extends PacketBaseProcess
	{
		public function PacketCSBoothLeaveWordProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSBoothLeaveWord2=pack as PacketCSBoothLeaveWord2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}