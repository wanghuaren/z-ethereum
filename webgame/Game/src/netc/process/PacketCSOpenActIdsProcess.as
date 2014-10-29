package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSOpenActIds2;

	public class PacketCSOpenActIdsProcess extends PacketBaseProcess
	{
		public function PacketCSOpenActIdsProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSOpenActIds2=pack as PacketCSOpenActIds2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}