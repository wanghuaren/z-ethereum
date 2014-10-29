package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructPlayerSSPkInfo2;

	public class StructPlayerSSPkInfoProcess extends PacketBaseProcess
	{
		public function StructPlayerSSPkInfoProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructPlayerSSPkInfo2=pack as StructPlayerSSPkInfo2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}