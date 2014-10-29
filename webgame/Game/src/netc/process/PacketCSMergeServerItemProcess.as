package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSMergeServerItem2;

	public class PacketCSMergeServerItemProcess extends PacketBaseProcess
	{
		public function PacketCSMergeServerItemProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSMergeServerItem2=pack as PacketCSMergeServerItem2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}