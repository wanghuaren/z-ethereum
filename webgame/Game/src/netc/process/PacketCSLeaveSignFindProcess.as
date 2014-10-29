package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSLeaveSignFind2;

	public class PacketCSLeaveSignFindProcess extends PacketBaseProcess
	{
		public function PacketCSLeaveSignFindProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSLeaveSignFind2=pack as PacketCSLeaveSignFind2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}