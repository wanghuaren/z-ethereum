package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCWSetPkUpdate2;

	public class PacketCWSetPkUpdateProcess extends PacketBaseProcess
	{
		public function PacketCWSetPkUpdateProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCWSetPkUpdate2=pack as PacketCWSetPkUpdate2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}