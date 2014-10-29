package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructAutoData2;

	public class StructAutoDataProcess extends PacketBaseProcess
	{
		public function StructAutoDataProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructAutoData2=pack as StructAutoData2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}