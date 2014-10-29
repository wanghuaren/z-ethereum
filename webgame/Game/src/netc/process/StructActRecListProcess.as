package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructActRecList2;

	public class StructActRecListProcess extends PacketBaseProcess
	{
		public function StructActRecListProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructActRecList2=pack as StructActRecList2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}