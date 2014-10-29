package netc.process
{
	import flash.utils.getQualifiedClassName;
	import engine.net.process.PacketBaseProcess;
	import engine.support.IPacket;
	import netc.packets2.PacketCSPkReadyOk2;

	public class PacketCSPkReadyOkProcess extends PacketBaseProcess
	{
		public function PacketCSPkReadyOkProcess()
		{
			super();
		}

		override public function process(pack:IPacket):IPacket
		{
			var p:PacketCSPkReadyOk2=pack as PacketCSPkReadyOk2;
			if (null == p)
			{
				throw new Error("can not canver pack for " + getQualifiedClassName(pack));
			}
			return p;
		}
	}
}