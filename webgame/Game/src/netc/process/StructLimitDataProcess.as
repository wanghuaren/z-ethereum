package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructLimitData2;

	public class StructLimitDataProcess extends PacketBaseProcess
	{
		public function StructLimitDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructLimitData2=pack as StructLimitData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}