package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSShortKeyLock2;

	public class PacketCSShortKeyLockProcess extends PacketBaseProcess
	{
		public function PacketCSShortKeyLockProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSShortKeyLock2=pack as PacketCSShortKeyLock2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}