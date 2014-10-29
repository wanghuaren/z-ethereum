package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructBagCell2;

	public class StructBagCellProcess extends PacketBaseProcess
	{
		public function StructBagCellProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructBagCell2=pack as StructBagCell2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}