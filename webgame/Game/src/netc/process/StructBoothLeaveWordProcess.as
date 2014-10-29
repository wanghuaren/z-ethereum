package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructBoothLeaveWord2;

	public class StructBoothLeaveWordProcess extends PacketBaseProcess
	{
		public function StructBoothLeaveWordProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructBoothLeaveWord2=pack as StructBoothLeaveWord2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}