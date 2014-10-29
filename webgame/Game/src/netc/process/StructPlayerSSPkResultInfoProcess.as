package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPlayerSSPkResultInfo2;

	public class StructPlayerSSPkResultInfoProcess extends PacketBaseProcess
	{
		public function StructPlayerSSPkResultInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPlayerSSPkResultInfo2=pack as StructPlayerSSPkResultInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}