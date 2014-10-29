package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructItemContainer2;

	public class StructItemContainerProcess extends PacketBaseProcess
	{
		public function StructItemContainerProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructItemContainer2=pack as StructItemContainer2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}