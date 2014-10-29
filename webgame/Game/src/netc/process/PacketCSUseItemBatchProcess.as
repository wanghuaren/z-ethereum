package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSUseItemBatch2;

	public class PacketCSUseItemBatchProcess extends PacketBaseProcess
	{
		public function PacketCSUseItemBatchProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSUseItemBatch2=pack as PacketCSUseItemBatch2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}