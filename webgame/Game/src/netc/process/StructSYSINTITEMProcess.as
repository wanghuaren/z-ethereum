package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSYSINTITEM2;

	public class StructSYSINTITEMProcess extends PacketBaseProcess
	{
		public function StructSYSINTITEMProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSYSINTITEM2=pack as StructSYSINTITEM2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}