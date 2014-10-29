package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructAutoConfig2;

	public class StructAutoConfigProcess extends PacketBaseProcess
	{
		public function StructAutoConfigProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructAutoConfig2=pack as StructAutoConfig2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}