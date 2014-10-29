package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructGetItemLog2;

	public class StructGetItemLogProcess extends PacketBaseProcess
	{
		public function StructGetItemLogProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructGetItemLog2=pack as StructGetItemLog2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}