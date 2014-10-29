package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructVariant2;

	public class StructVariantProcess extends PacketBaseProcess
	{
		public function StructVariantProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructVariant2=pack as StructVariant2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}