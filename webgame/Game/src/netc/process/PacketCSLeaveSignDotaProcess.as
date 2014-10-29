package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSLeaveSignDota2;

	public class PacketCSLeaveSignDotaProcess extends PacketBaseProcess
	{
		public function PacketCSLeaveSignDotaProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSLeaveSignDota2=pack as PacketCSLeaveSignDota2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}