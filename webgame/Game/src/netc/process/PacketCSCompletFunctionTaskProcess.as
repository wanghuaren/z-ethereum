package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSCompletFunctionTask2;

	public class PacketCSCompletFunctionTaskProcess extends PacketBaseProcess
	{
		public function PacketCSCompletFunctionTaskProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSCompletFunctionTask2=pack as PacketCSCompletFunctionTask2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}