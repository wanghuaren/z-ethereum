package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.StructSaleBagCell2;

	public class StructSaleBagCellProcess extends PacketBaseProcess
	{
		public function StructSaleBagCellProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:StructSaleBagCell2=pack as StructSaleBagCell2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}